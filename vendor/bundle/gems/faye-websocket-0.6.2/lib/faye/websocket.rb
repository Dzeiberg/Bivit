# API references:
#
# * http://dev.w3.org/html5/websockets/
# * http://dvcs.w3.org/hg/domcore/raw-file/tip/Overview.html#interface-eventtarget
# * http://dvcs.w3.org/hg/domcore/raw-file/tip/Overview.html#interface-event

require 'forwardable'
require 'stringio'
require 'uri'
require 'eventmachine'
require 'websocket/driver'

module Faye
  autoload :EventSource, File.expand_path('../eventsource', __FILE__)
  autoload :RackStream,  File.expand_path('../rack_stream', __FILE__)

  class WebSocket
    root = File.expand_path('../websocket', __FILE__)

    autoload :Adapter, root + '/adapter'
    autoload :API,     root + '/api'
    autoload :Client,  root + '/client'

    ADAPTERS = {
      'goliath'  => :Goliath,
      'rainbows' => :Rainbows,
      'thin'     => :Thin
    }

    def self.determine_url(env)
      secure = Rack::Request.new(env).ssl?
      scheme = secure ? 'wss:' : 'ws:'
      "#{ scheme }//#{ env['HTTP_HOST'] }#{ env['REQUEST_URI'] }"
    end

    def self.ensure_reactor_running
      Thread.new { EventMachine.run } unless EventMachine.reactor_running?
      Thread.pass until EventMachine.reactor_running?
    end

    def self.load_adapter(backend)
      const = Kernel.const_get(ADAPTERS[backend]) rescue nil
      require(backend) unless const
      path = File.expand_path("../adapters/#{backend}.rb", __FILE__)
      require(path) if File.file?(path)
    end

    def self.websocket?(env)
      ::WebSocket::Driver.websocket?(env)
    end

    attr_reader :env
    include API

    def initialize(env, protocols = nil, options = {})
      WebSocket.ensure_reactor_running

      @env     = env
      @url     = WebSocket.determine_url(@env)
      @driver  = ::WebSocket::Driver.rack(self, :protocols => protocols)
      @stream  = Stream.new(self)

      if callback = @env['async.callback']
        callback.call([101, {}, @stream])
      end

      super(options)
      @driver.start
    end

    def write(data)
      @stream.write(data)
    end

    def rack_response
      [ -1, {}, [] ]
    end

    class Stream < RackStream
      def fail
        @socket_object.__send__(:finalize, '', 1006)
      end

      def receive(data)
        @socket_object.__send__(:parse, data)
      end
    end

  end
end


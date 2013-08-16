# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mad_chatter"
  s.version = "0.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrew Havens"]
  s.date = "2012-02-28"
  s.description = "Mad Chatter is a fun, easy to customize chat server, utilizing HTML 5 Web Sockets"
  s.email = ["email@andrewhavens.com"]
  s.executables = ["mad_chatter"]
  s.files = ["bin/mad_chatter"]
  s.homepage = "http://github.com/andrewhavens/mad_chatter"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.0"
  s.summary = "Mad Chatter is a fun, easy to customize chat server, utilizing HTML 5 Web Sockets"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, [">= 0"])
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
      s.add_runtime_dependency(%q<em-websocket>, [">= 0"])
      s.add_runtime_dependency(%q<daemons>, ["= 1.1.4"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<rb-fsevent>, [">= 0"])
      s.add_development_dependency(%q<ruby-growl>, [">= 0"])
    else
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<em-websocket>, [">= 0"])
      s.add_dependency(%q<daemons>, ["= 1.1.4"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<rb-fsevent>, [">= 0"])
      s.add_dependency(%q<ruby-growl>, [">= 0"])
    end
  else
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<em-websocket>, [">= 0"])
    s.add_dependency(%q<daemons>, ["= 1.1.4"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<rb-fsevent>, [">= 0"])
    s.add_dependency(%q<ruby-growl>, [">= 0"])
  end
end

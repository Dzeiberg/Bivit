class BivsController < ApplicationController
  
  before_filter :set_user
  
  def index
    if params[:mailbox] == "sent"
      @bivs = @user.sent_bivs
    elsif params[:mailbox] == "bivbox"
      @bivs = @user.received_messages
    #elsif params[:mailbox] == "archived"
     # @bivs = @user.archived_bivs
    end
  end
  
  def new
    @biv = Biv.new
    if params[:reply_to]
      @reply_to = User.find_by_user_id(params[:reply_to])
      unless @reply_to.nil?
        @biv.recepient_id = @reply_to.user_id
      end
    end
  end
  
  def create
    @biv = Biv.new(params[:biv])
    @biv.sender_id = @user.user_id
    if @biv.save
      flash[:notice] = "Biv has been sent"
      redirect_to user_bivss_path(current_user, :mailbox=>:inbox)
    else
      render :action => :new
    end
  end

  def show
    @biv = Biv.readingbiv(params[:id],@user.user_id)
  end
  
  def delete_multiple
      if params[:delete]
        params[:delete].each { |id|
          @biv = Biv.find(id)
          @biv.mark_biv_deleted(@biv.id,@user.user_id) unless @biv.nil?
        }
        flash[:notice] = "Bivs deleted"
      end
      redirect_to user_bivss_path(@user, @bivs)
  end
  
  private
    def set_user
      @user = current_user
    end
end
class SessionsController < ApplicationController

def new
end

def create
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    self.current_user = @user
    redirect_to 'articles_path'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end

def destroy
sign_out
    redirect_to root_url

end

end

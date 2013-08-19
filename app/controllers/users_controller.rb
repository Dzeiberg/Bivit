class UsersController < ApplicationController
	
	before_filter :signed_in_user, 
		      only: [:index, :edit, :update, :destroy, :following, :followers, :feed]
	before_filter :correct_user, only: [:edit, :update]

	@@config = { 
      :site => 'https://api.linkedin.com',
      :authorize_path => '/uas/oauth/authenticate',
      :request_token_path => '/uas/oauth/requestToken?scope=r_basicprofile+r_fullprofile',
      :access_token_path => '/uas/oauth/accessToken' 
  }

	def new
	    @user = User.new
	end

	def following
	  @title = "Following"
	  @user = User.find(params[:id])
	  @users = @user.followed_users.paginate(page: params[:page])
	  render 'show_follow'
	end

	def followers
	  @title = "Followers"
	  @user = User.find(params[:id])
	  @users = @user.followers.paginate(page:params[:page])
	  render 'show_follow'
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to Bivit!"
			redirect_to @user
		else
			render 'new'
		end
	end
      
	def edit
		@user = User.find(params[:id])
	end

	def destroy
	  User.find(params[:id].destroy)
	  flash[:success] = "User destroyed."
	  redirect_to users_url
	end
	
	def index
	  @users= User.paginate(page: params[:page])
	end

	def update
  @user = User.find(params[:id])
  respond_to do |format|
    if @user.update_without_password(params[:user])
      format.html { redirect_to root_url, flash[:notice] = SUCCESSFUL_REGISTRATION_UPDATE_MSG }
      format.json { head :no_content }
    else
      format.html { render action: "edit" }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
   end
end  

	def feed
		Article.where("user_id = ?", id)
	end
	
  def get_client
    @linkedin_oauth_setting = LinkedinOauthSetting.find_by_user_id(params[:id])
    if !@linkedin_oauth_setting.nil?
	    @client = LinkedIn::Client.new('iv6uehul4g5m', 'wtMfG2MbFerSULTC', @@config)
	    @client.authorize_from_access(@linkedin_oauth_setting.atoken, @linkedin_oauth_setting.asecret)
	    @client
	   end
  end

  def get_basic_profile
    @bprofile = BasicProfile.find_by_user_id(params[:id])
    if @bprofile.nil?
      @client = get_client
      @profile = @client.profile(:fields => ["first-name", "last-name", "maiden-name", "formatted-name" ,:headline, :location, :industry, :summary, :specialties, "picture-url", "public-profile-url"])

      @basic_profile = @profile.to_hash
      @basic_profile[:location] = @basic_profile["location"]["name"]
      @new_basic_profile = BasicProfile.new(@basic_profile)
      @new_basic_profile.user = User.find_by_id(params[:id])
      @new_basic_profile.save 
      @new_basic_profile
    else
      @bprofile
    end
  end

  def get_full_profile
    @fprofile = FullProfile.find_by_user_id(params[:id])
    if @fprofile.nil?
      @client = get_client
      @full_profile = @client.profile(:fields => [:associations, :honors, :interests, ])
      @full_profile = @full_profile.to_hash
      @new_full_profile = FullProfile.new(@full_profile)
      @new_full_profile.user = User.find_by_id(params[:id])
      @new_full_profile.save 
      @new_full_profile
    else
      @fprofile
    end
  end

  def get_positions
  	@full_profile = FullProfile.find_by_id(params[:id])
    @positions = Position.find_all_by_full_profile_id(@full_profile.id)
    if @positions.empty?
      @client = get_client
      @positions = @client.profile(:fields => [:positions]).positions.all
      @positions.each do |p|
        if p.is_current == "true"
          Position.create(
            title: p.title, 
            summary: p.summary, 
            start_date: Date.parse("1/#{p.start_date.month ? p.start_date.month : 1}/#{p.start_date.year}"), 
            end_date: Date.parse("1/#{p.end_date.month ? p.end_date.month : 1}/#{p.end_date.year}"), 
            is_current: p.is_current, 
            company: p.company.name, 
            full_profile_id: current_user.full_profile.id)
        else
          Position.create(
            title: p.title, 
            summary: p.summary, 
            start_date: Date.parse("1/#{p.start_date.month ? p.start_date.month : 1}/#{p.start_date.year}"), 
            is_current: p.is_current, 
            company: p.company.name, 
            full_profile_id: current_user.full_profile.id)
        end
      end
      User.find_by_id(params[:id]).full_profile.positions
    else
      @positions
    end
  end

  def get_educations
  	@full_profile = FullProfile.find_by_id(params[:id])
    @educations = Education.find_all_by_full_profile_id(@full_profile.id)
    if @educations.empty?
      @client = get_client
      @educations = @client.profile(:fields => [:educations]).educations.all
      @educations.each do |e|
        @new_educations = Education.create(
          school_name: e.school_name, 
          field_of_study: e.field_of_study, 
          start_date: Date.parse("1/#{e.end_date.month ? p.end_date.month : 1}/#{e.end_date.year}"), 
          end_date: Date.parse("1/#{e.end_date.month ? p.end_date.month : 1}/#{e.end_date.year}"), 
          degree: e.degree, 
          activities: e.activities, 
          notes: e.notes, 
          full_profile_id: current_user.full_profile.id)  
      end
      User.find_by_id(params[:id]).full_profile.educations
    else
      @educations
    end
  end

	def show
	  @user = User.find(params[:id])
	  @articles = @user.articles.paginate(page: params[:page])
	  @client = get_client
	  if !@client.nil?
		  @basic_profile = get_basic_profile
		  @full_profile = get_full_profile
		  @positions = get_positions
		  @educations = get_educations
	  end
	end

	private
		def signed_in_user
		  unless signed_in?
		    store_location
		    redirect_to signin_url, notice: "Please sign in." unless signed_in?
		  end
		end
		
		def correct_user
		  @user = User.find(params[:id])
		  redirect_to(root_path) unless current_user?(@user)
		end

		def admin_user
		  redirect_to(root_path) unless current_user.admin?
		end
	
end

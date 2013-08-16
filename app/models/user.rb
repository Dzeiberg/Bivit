class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
require 'bcrypt'
 attr_accessible :first_name, :last_name, :username, :email, :password, :password_confirmation, :remember_me
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true
  has_many :rooms
  has_many :messages
  has_many :comments, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
				 class_name: "Relationship",
				 dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_one :basic_profile
  has_one :full_profile
  has_one :linkedin_oauth_setting

  include BCrypt

  def afeed
	articles
  end
	
  def following?(other_user)
	relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
	relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
	relationships.find_by_followed_id(other_user.id).destroy
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  private
	def create_remember_token
	self.remember_token = SecureRandom.urlsafe_base64
  end
end

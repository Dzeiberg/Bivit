  class Room < ActiveRecord::Base
    attr_accessible :name, :recipients
    has_many :messages
    belongs_to :owner, class_name: 'User', :foreign_key => :user_id
	has_many :memberships
	has_many :members, through: :memberships, :source => :user
  end

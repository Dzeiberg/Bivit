class Membership < ActiveRecord::Base
  attr_accessible :adder_id, :participant_id
  
  belongs_to :room, class_name "Room"
  belongs_to :adder, class_name "User"
  belongs_to :participant, class_name "User"
  
  validates :adder_id, presence:true
  validates :participant_id, presence:true
end

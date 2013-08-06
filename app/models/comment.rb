class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  attr_accessible :body
end

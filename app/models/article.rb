class Article < ActiveRecord::Base
  attr_accessible :headline, :content, :takeaway, :tags, :article_id
  belongs_to :user
  has_many :comments
  validates :user_id, presence: true
  validates :content, presence: true
  validates :tags, presence: true
  validates :headline, presence: true
  validates :takeaway, presence: true, length: { maximum: 140 }
  default_scope order: 'articles.created_at DESC'

end

class Article < ActiveRecord::Base
  attr_accessible :author, :content, :teaser, :title, :article_id
  belongs_to :user
  has_many :comments
  validates :user_id, presence: true
  validates :content, presence: true
  validates :author, presence: true
  validates :title, presence: true
  validates :teaser, presence: true, length: { maximum: 140 }
  default_scope order: 'articles.created_at DESC'

end

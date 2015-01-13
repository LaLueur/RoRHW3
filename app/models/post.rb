class Post < ActiveRecord::Base
#TODO create new field with total score (votes) in post model :vote_all:integer

  include VoteModule
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :comments, dependent: :destroy
  #has_many :votes, :as => :voteable
  has_many :votes
  has_many :tags, through: :post_tags
  validates :title, presence: true, uniqueness: true, length: 5..140
  validates :body, presence: true, length: {minimum: 140}
  validates_presence_of :user_id
  scope :newest, -> { order ('created_at desc') }
  scope :active, -> { order ('updated_at desc') }
  scope :popular, -> { order ('total_score desc') }

  def display_tags
    tags = self.tags
    return_value = ''
    unless tags.empty?
      last_index = tags.size - 1
      tags.each_with_index { |tag, index|
        return_value += tag.name
        return_value += ',' unless index == last_index
      }
    end
    return_value
  end
end

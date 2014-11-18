class Post < ActiveRecord::Base
  belongs_to :user
  validates :title, :presence => true, :uniqueness => true, :length => 5..100
  validates_presence_of :body
  validates_presence_of :user_id
end

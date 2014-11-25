class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  #has_many :votes, :as => :voter
  has_many :votes
  has_secure_password
end

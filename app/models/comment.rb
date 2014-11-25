class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  after_save :touch_post

  def touch_post
    self.post.touch
  end
end

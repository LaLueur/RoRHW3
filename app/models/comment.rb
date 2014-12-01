class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  #validates_presence_of :user

  validate do |comment|
    comment.errors.add(:base, 'Please login first in order to comment.') if comment.user.blank?
  end

  after_save :touch_post

  def touch_post
    self.post.touch
  end
end

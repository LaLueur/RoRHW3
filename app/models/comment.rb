class Comment < ActiveRecord::Base
  has_ancestry
  belongs_to :post
  belongs_to :user


  validate do |comment|
    comment.errors.add(:base, 'Please login first in order to comment.') if comment.user.blank?
  end

  after_save :touch_post

  def touch_post
    self.post.touch
  end
end

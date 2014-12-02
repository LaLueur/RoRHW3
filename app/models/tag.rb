class Tag < ActiveRecord::Base
  has_many :post_tags
  has_many :posts, through: :post_tags

  validates_uniqueness_of :name

  def destroy
    super unless self.post_tags.size > 1
  end
end

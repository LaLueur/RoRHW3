class PostTag < ActiveRecord::Base
  belongs_to :post
  belongs_to :tag

  before_destroy :destroy_tag

  def destroy_tag
    tag = self.tag
    tag.destroy
  end
end

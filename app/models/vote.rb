class Vote < ActiveRecord::Base
  VOTE_RANGE = [-1 , 1]
=begin
  belongs_to :voteable, class_name: 'Post',
                        foreign_key: 'post_id'
  belongs_to :voter, class_name: 'User',
                     foreign_key: 'user_id'

  validates_presence_of :score , :voteable , :voter
  validates_inclusion_of :score, :in => VOTE_RANGE
=end

  belongs_to :post
  belongs_to :user

  validates_presence_of :score , :post, :user
  validates_inclusion_of :score, :in => VOTE_RANGE
  #ToDo: check voter & voteable ids
  validates_uniqueness_of :user_id, :scope => :post_id

  after_save :update_post_total_score

  def update_post_total_score
    post = self.post
    new_total_score = post.total_score
    new_total_score += self.score
    post.update_attribute(:total_score, new_total_score)
  end

  # def update_post_total_score
  #   self.post.total_score += self.score
  #   self.post.save
  # end

end
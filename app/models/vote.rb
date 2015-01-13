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

  belongs_to :votable, :polymorphic => true
  belongs_to :user

  validates_presence_of :score , :votable, :user
  validates_inclusion_of :score, :in => VOTE_RANGE
  #ToDo: check voter & voteable ids
  validates_uniqueness_of :user_id, scope: :votable_id
  after_save :update_post_total_score
  before_destroy :update_post_total_score

  def update_post_total_score
    votable = self.votable
    new_total_score = votable.total_score
    new_total_score += self.score
    votable.update_attributes(total_score: new_total_score)
  end

end

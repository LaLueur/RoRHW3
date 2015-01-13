module VoteModule
  def self.included(base)
    base.module_eval {
      after_create :create_vote
      has_one :vote, :dependent => :destroy, :as => :votable
    }
  end

  protected
  def create_vote
    self.vote = Vote.create(:score => 0)
  end
end
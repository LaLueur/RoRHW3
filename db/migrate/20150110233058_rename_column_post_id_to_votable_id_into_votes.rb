class RenameColumnPostIdToVotableIdIntoVotes < ActiveRecord::Migration
  def change
    rename_column :votes, :post_id, :votable_id
  end
end

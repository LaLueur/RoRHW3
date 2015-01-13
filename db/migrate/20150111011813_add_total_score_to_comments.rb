class AddTotalScoreToComments < ActiveRecord::Migration
  def change
    add_column :comments, :total_score, :integer, :default => 0
  end
end

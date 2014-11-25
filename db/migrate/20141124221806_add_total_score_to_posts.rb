class AddTotalScoreToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :total_score, :integer, :default => 0
  end

  def down
    remove_column :posts, :total_score
  end
end
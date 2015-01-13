class AddTypeIntoVote < ActiveRecord::Migration
  def change
    change_table :votes do |f|
      f.string :votable_type
    end
  end
end

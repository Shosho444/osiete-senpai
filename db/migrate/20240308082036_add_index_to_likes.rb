class AddIndexToLikes < ActiveRecord::Migration[7.1]
  def change
    add_index :likes, [:user_id, :likeable_type, :likeable_id], unique: true
  end
end
class AddIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :likes, %w[likeable_type likeable_id user_id], unique: true
  end
end

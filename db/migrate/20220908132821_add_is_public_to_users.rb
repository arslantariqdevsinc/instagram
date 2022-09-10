class AddIsPublicToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_private, :boolean, default: false
  end
end

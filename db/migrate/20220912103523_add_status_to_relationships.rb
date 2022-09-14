class AddStatusToRelationships < ActiveRecord::Migration[6.0]
  def change
    add_column :relationships, :status, :integer
  end
end

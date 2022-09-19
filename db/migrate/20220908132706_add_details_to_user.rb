class AddDetailsToUser < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :fullname
      t.string :bio
      t.string :website
    end
  end
end

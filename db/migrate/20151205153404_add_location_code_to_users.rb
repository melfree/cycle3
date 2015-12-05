class AddLocationCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location_code, :integer, default: 0
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false, default: ""
      t.string :photo
      t.text :description
      
      t.integer :blocks, default: 0, null: false
      t.integer :guest_blocks, default: 0, null: false
      t.integer :dinex, default: 0, null: false
      
      t.integer :status, default: 0, null: false, index: true
      t.integer :location
      
      t.boolean :find_match
      t.datetime :find_match_start_time
      t.integer :matched_user_id
      
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false, default: ""
      t.string :photo
      t.text :description
      
      t.integer :blocks, default: 0, null: false
      t.integer :guest_blocks, default: 0, null: false
      t.integer :dinex, default: 0, null: false
      
      t.string :status
      t.string :location

      t.timestamps
    end
  end
end

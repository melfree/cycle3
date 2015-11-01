class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.references :seller, references: :users, index: true, foreign_key: true
      t.references :buyer, references: :users, index: true, foreign_key: true
      
      t.text :description
      
      t.datetime :time
      t.integer :location
      
      t.integer :blocks,default: 0, null: false
      t.integer :guest_blocks,default: 0, null: false
      t.integer :dinex,default: 0, null: false
      t.integer :status

      t.timestamps
    end
  end
end

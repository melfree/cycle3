class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false, default: ""
      t.string :photo
      
      t.text :description
      
      # Dinex, blocks, or both
      t.integer :meal_plan_code, default: 0, null: false
      
      # Inactive, buying in deal, buying searching, sellng searching, or selling in deal
      t.integer :status_code, default: 0, null: false, index: true
      
      # Prioritize who gets matched first
      t.datetime :search_start_time
      
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end

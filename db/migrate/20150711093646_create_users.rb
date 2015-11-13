class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false, default: ""
      t.string :photo
      
      t.text :description
      
      # Dinex, blocks, or both
      t.integer :meal_plan_code, default: 0, null: false
      
      # Inactive, buyer, or seller
      t.integer :status_code, default: 0, null: false, index: true
      
      # Id of the user's current deal.
      # If this is  null, then the buyer/seller is currently searching.
      t.integer :current_deal_id
      
      # Prioritize who gets matched first
      t.datetime :search_start_time
      
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end

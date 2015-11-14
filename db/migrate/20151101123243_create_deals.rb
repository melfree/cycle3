class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.integer :seller_id, index: true
      t.integer :buyer_id, index: true
      
      t.text :description
      
      # Time for when the deal is completed
      t.datetime :seller_finished_at
      t.datetime :buyer_finished_at
      
      # Cancelled, completed, or pending
      t.integer :seller_status_code, default: 0, null: false, index: true
      t.integer :buyer_status_code, default: 0, null: false, index: true

      t.timestamps
    end
  end
end

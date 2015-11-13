class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :deal_id, null: false, index: true
      
      t.integer :user_id, null: false
      
      t.text :content, null: false, default: ""

      t.timestamps
    end
  end
end

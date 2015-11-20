class AddNotifyByEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :notify_by_email, :boolean, default: true
    add_column :users, :friends_only, :boolean, default: false
  end
end

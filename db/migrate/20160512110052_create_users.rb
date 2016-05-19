class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account_id, index: true, null: false
      t.string :user_key, index: true, null: false
      t.string :last_chat_key, null: false
      t.string :last_msg_id, null: false
      t.integer :status, index: true, null: false, default: 10

      t.timestamps null: false
    end
  end
end

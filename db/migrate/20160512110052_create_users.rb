class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account_id, index: true, null: false
      t.column :user_key, 'BIGINT UNSIGNED', index: true, null: false
      t.column :last_chat_key, 'BIGINT UNSIGNED', null: false
      t.column :last_msg_id, 'BIGINT UNSIGNED', null: false
      t.integer :status, index: true, null: false, default: 10

      t.timestamps null: false
    end
  end
end

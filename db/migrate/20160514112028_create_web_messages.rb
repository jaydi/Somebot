class CreateWebMessages < ActiveRecord::Migration
  def change
    create_table :web_messages do |t|
      t.string :msg_type, null: false
      t.column :msg_id, 'BIGINT UNSIGNED', index: true, null: false
      t.column :user_key, 'BIGINT UNSIGNED', index: true, null: false
      t.column :chat_key, 'BIGINT UNSIGNED', index: true, null: false
      t.text :text, null: false
      t.integer :bound, null: false

      t.timestamps null: false
    end
  end
end

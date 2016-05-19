class CreateWebMessages < ActiveRecord::Migration
  def change
    create_table :web_messages do |t|
      t.string :msg_type, null: false
      t.integer :msg_id, limit: 20, index: true, null: false
      t.integer :user_key, limit: 20, index: true, null: false
      t.integer :chat_key, limit: 20, index: true, null: false
      t.text :text, null: false
      t.integer :bound, null: false

      t.timestamps null: false
    end
  end
end

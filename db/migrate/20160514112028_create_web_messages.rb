class CreateWebMessages < ActiveRecord::Migration
  def change
    create_table :web_messages do |t|
      t.string :msg_type, null: false
      t.string :msg_id, index: true, null: false
      t.string :user_key, index: true, null: false
      t.string :chat_key, index: true, null: false
      t.text :text, null: false
      t.integer :bound, null: false

      t.timestamps null: false
    end
  end
end
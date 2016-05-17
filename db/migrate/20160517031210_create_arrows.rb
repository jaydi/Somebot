class CreateArrows < ActiveRecord::Migration
  def change
    create_table :arrows do |t|
      t.string :origin, index: true, null: false
      t.string :destination, index: true, null: false
      t.integer :status, null: false, default: 10

      t.timestamps null: false
    end
  end
end

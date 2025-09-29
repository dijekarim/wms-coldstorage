class CreateStockItems < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_items do |t|
      t.references :warehouse, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :quantity, null: false, default: 0
      t.references :location, foreign_key: { to_table: :locations }, null: true
      t.date :expired_date
      t.boolean :confirmed, default: false # whether manager confirmed incoming (put away)
      t.timestamps
    end

    add_index :stock_items, [ :warehouse_id, :name ]
  end
end

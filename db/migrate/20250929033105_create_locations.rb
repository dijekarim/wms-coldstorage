class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.references :warehouse, null: false, foreign_key: true
      t.string :code, null: false # e.g., A1, B2
      t.timestamps
    end

    add_index :locations, [ :warehouse_id, :code ], unique: true
  end
end

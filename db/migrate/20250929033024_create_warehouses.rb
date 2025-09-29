class CreateWarehouses < ActiveRecord::Migration[8.0]
  def change
    create_table :warehouses do |t|
      t.string :name, null: false
      t.boolean :cold_storage, default: true
      t.timestamps
    end
  end
end

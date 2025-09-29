# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# create users
User.create!(email: 'admin@example.com', password: 'password', role: :admin)
User.create!(email: 'manager@example.com', password: 'password', role: :manager)
User.create!(email: 'viewer@example.com', password: 'password', role: :viewer)

# warehouses
w1 = Warehouse.create!(name: "Jakarta Cold 1", cold_storage: true)
w2 = Warehouse.create!(name: "Bandung Cold 2", cold_storage: true)

# create sample locations in priority order: A1,A2,B1,B2
[ 'A1', 'A2', 'B1', 'B2', 'C1', 'C2' ].each do |code|
  w1.locations.create!(code: code)
  w2.locations.create!(code: code)
end

# sample unassigned stock (incoming)
w1.stock_items.create!(name: "Chicken Breast", quantity: 100, expired_date: Date.today + 10)
w1.stock_items.create!(name: "Ice Cream", quantity: 50, expired_date: Date.today + 30)

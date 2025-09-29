class Warehouse < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :stock_items, dependent: :destroy

  validates :name, presence: true
end

class Location < ApplicationRecord
  belongs_to :warehouse
  belongs_to :stock_item, optional: true

  validates :code, presence: true
  validates :code, uniqueness: { scope: :warehouse_id }

  def occupied?
    stock_item_id.present?
  end
end

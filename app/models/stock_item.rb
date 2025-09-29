class StockItem < ApplicationRecord
  belongs_to :warehouse
  belongs_to :location, optional: true # convenience, mirrors locations.stock_item
  has_one :location_record, class_name: "Location", foreign_key: :stock_item_id

  validates :name, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  scope :not_expired, -> { where("expired_date IS NULL OR expired_date >= ?", Date.current) }
  scope :by_expiry, -> { order(Arel.sql("expired_date IS NULL, expired_date ASC")) } # NULLS LAST

  # Reduce quantity safely
  def reduce!(amount)
    raise ArgumentError, "amount must be > 0" unless amount.positive?
    raise "Item expired" if expired?

    transaction do
      reload
      raise "Not enough stock" if quantity < amount
      update!(quantity: quantity - amount)
      if quantity - amount == 0
        # free location if any
        if location_record
          location_record.update!(stock_item_id: nil)
          update!(location_id: nil)
        end
      end
    end
  end

  def expired?
    expired_date.present? && expired_date < Date.current
  end
end

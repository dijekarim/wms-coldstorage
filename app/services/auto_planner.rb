class AutoPlanner
  class NoAvailableLocation < StandardError; end

  # warehouse: Warehouse object
  # stock_item: StockItem (not yet assigned)
  def self.assign_location!(warehouse:, stock_item:)
    # Ensure stock_item has correct warehouse
    raise ArgumentError, "warehouse mismatch" if warehouse.id != stock_item.warehouse_id

    ActiveRecord::Base.transaction do
      # Find first available location ordered by code (A1, A2, B1...).
      # Lock selected location to prevent concurrent assignments.
      loc = Location.where(warehouse: warehouse, stock_item_id: nil)
                    .order(Arel.sql("string_to_array(code, '')")) # fallback - but more simply:
                    .order(:code) # lexicographic; works for typical codes like A1,A2,B1
                    .limit(1)
                    .lock("FOR UPDATE")
                    .first

      raise NoAvailableLocation, "no available location in warehouse #{warehouse.id}" unless loc

      # Assign
      loc.update!(stock_item_id: stock_item.id)
      stock_item.update!(location_id: loc.id, confirmed: true)
      return loc
    end
  end
end

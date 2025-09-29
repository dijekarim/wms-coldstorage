class DashboardsController < ApplicationController
  def index
    case current_user.role
    when "admin"
      redirect_to admin_dashboard_path
    when "manager"
      redirect_to manager_dashboard_path
    when "viewer"
      redirect_to viewer_dashboard_path
    else
      redirect_to root_path
    end
  end

  def admin
    # authorize :dashboard, :admin?
    @warehouses_count = Warehouse.count
    @users_count = User.count
    @stock_count = StockItem.sum(:quantity)
  end

  def manager
    @warehouse = Warehouse.first # or scope by manager's assigned warehouse
    @stock_count = @warehouse.stock_items.sum(:quantity)
    @expiring_soon = @warehouse.stock_items
                                .where("expired_date <= ?", Date.today + 7)
                                .count
    @unconfirmed = @warehouse.stock_items.where(confirmed: false).count
  end

  def viewer
    @warehouse = Warehouse.first
    @stock_count = @warehouse.stock_items.sum(:quantity)
    @expiring_soon = @warehouse.stock_items
                                .where("expired_date <= ?", Date.today + 7)
                                .count
  end
end

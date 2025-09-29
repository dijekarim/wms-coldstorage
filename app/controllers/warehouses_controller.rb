class WarehousesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_warehouse, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin, only: [:new, :create, :edit, :update, :destroy]

  def index
    @warehouses = Warehouse.all.order(:name)
  end

  def show
    @locations = @warehouse.locations.order(:code)
    @stock_items = @warehouse.stock_items.includes(:location).order(:name)
  end

  def new
    @warehouse = Warehouse.new
  end

  def create
    @warehouse = Warehouse.new(warehouse_params)
    
    if @warehouse.save
      redirect_to @warehouse, notice: 'Warehouse was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @warehouse.update(warehouse_params)
      redirect_to @warehouse, notice: 'Warehouse was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @warehouse.destroy
    redirect_to warehouses_url, notice: 'Warehouse was successfully deleted.'
  end

  private

  def set_warehouse
    @warehouse = Warehouse.find(params[:id])
  end

  def warehouse_params
    params.require(:warehouse).permit(:name)
  end

  def authorize_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end
end
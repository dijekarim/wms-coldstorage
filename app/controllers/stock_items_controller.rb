class StockItemsController < ApplicationController
  before_action :set_warehouse
  before_action :set_stock_item, only: [:show, :edit, :update, :destroy, :put_away, :reduce]

  # GET /warehouses/:warehouse_id/stock_items
  def index
    authorize StockItem
    @stock_items = @warehouse.stock_items.includes(:location)
    @stock_items = @stock_items.order(expired_date: :asc) if params[:sort] == "expiry"
  end

  # GET /warehouses/:warehouse_id/stock_items/:id
  def show
    authorize @stock_item
  end

  # GET /warehouses/:warehouse_id/stock_items/new
  def new
    authorize StockItem
    @stock_item = @warehouse.stock_items.build
  end

  # POST /warehouses/:warehouse_id/stock_items
  def create
    authorize StockItem
    @stock_item = @warehouse.stock_items.build(stock_item_params)
    
    if @stock_item.save
      redirect_to warehouse_stock_items_path(@warehouse), notice: 'Stock item was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /warehouses/:warehouse_id/stock_items/:id/edit
  def edit
    authorize @stock_item
  end

  # PATCH/PUT /warehouses/:warehouse_id/stock_items/:id
  def update
    authorize @stock_item
    
    if @stock_item.update(stock_item_params)
      redirect_to warehouse_stock_item_path(@warehouse, @stock_item), notice: 'Stock item was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /warehouses/:warehouse_id/stock_items/:id
  def destroy
    authorize @stock_item
    @stock_item.destroy
    redirect_to warehouse_stock_items_path(@warehouse), notice: 'Stock item was successfully deleted.'
  end

  # PUT /warehouses/:warehouse_id/stock_items/:id/put_away
  # Manager confirms incoming and system assigns location via AutoPlanner
  def put_away
    authorize @stock_item, :put_away?
    
    if @stock_item.confirmed
      redirect_to warehouse_stock_item_path(@warehouse, @stock_item), 
                  alert: 'Stock item has already been put away.'
      return
    end

    begin
      location = AutoPlanner.assign_location!(warehouse: @warehouse, stock_item: @stock_item)
      redirect_to warehouse_stock_item_path(@warehouse, @stock_item), 
                  notice: "Stock item assigned to location #{location.code}."
    rescue AutoPlanner::NoAvailableLocation => e
      redirect_to warehouse_stock_item_path(@warehouse, @stock_item), 
                  alert: e.message
    end
  end

  # POST /warehouses/:warehouse_id/stock_items/:id/reduce
  # Params: amount
  def reduce
    authorize @stock_item, :reduce?
    amount = params[:amount].to_i
    
    if amount <= 0
      redirect_to warehouse_stock_item_path(@warehouse, @stock_item), 
                  alert: 'Amount must be greater than 0.'
      return
    end

    begin
      @stock_item.reduce!(amount)
      redirect_to warehouse_stock_item_path(@warehouse, @stock_item), 
                  notice: "Stock reduced by #{amount} units."
    rescue => e
      redirect_to warehouse_stock_item_path(@warehouse, @stock_item), 
                  alert: e.message
    end
  end

  private

  def set_warehouse
    @warehouse = Warehouse.find(params[:warehouse_id])
  end

  def set_stock_item
    @stock_item = @warehouse.stock_items.find(params[:id])
  end

  def stock_item_params
    params.require(:stock_item).permit(:name, :quantity, :expired_date)
  end
end

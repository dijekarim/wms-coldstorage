class LocationsController < ApplicationController
  before_action :set_warehouse
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /warehouses/:warehouse_id/locations
  def index
    authorize Location
    @locations = @warehouse.locations.includes(:stock_item).order(:code)
  end

  # GET /warehouses/:warehouse_id/locations/:id
  def show
    authorize @location
  end

  # GET /warehouses/:warehouse_id/locations/new
  def new
    authorize Location
    @location = @warehouse.locations.build
  end

  # POST /warehouses/:warehouse_id/locations
  def create
    authorize Location
    @location = @warehouse.locations.build(location_params)
    
    if @location.save
      redirect_to warehouse_locations_path(@warehouse), notice: 'Location was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /warehouses/:warehouse_id/locations/:id/edit
  def edit
    authorize @location
  end

  # PATCH/PUT /warehouses/:warehouse_id/locations/:id
  def update
    authorize @location
    
    if @location.update(location_params)
      redirect_to warehouse_location_path(@warehouse, @location), notice: 'Location was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /warehouses/:warehouse_id/locations/:id
  def destroy
    authorize @location
    
    if @location.occupied?
      redirect_to warehouse_locations_path(@warehouse), 
                  alert: 'Cannot delete location that contains stock items.'
      return
    end
    
    @location.destroy
    redirect_to warehouse_locations_path(@warehouse), notice: 'Location was successfully deleted.'
  end

  private

  def set_warehouse
    @warehouse = Warehouse.find(params[:warehouse_id])
  end

  def set_location
    @location = @warehouse.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:code)
  end
end

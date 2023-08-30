class Api::V0::VendorsController < ApplicationController
  def index
    render json: VendorSerializer.new(Vendor.all)
  end

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  private

  def vendor_params
    params.permit(:name, :num_employees, :market_id)
  end
end
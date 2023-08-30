class Api::V0::MarketVendorsController < ApplicationController
  
  def create
    @market_vendor = MarketVendor.create(market_vendor_params)
    @market_vendor.save
    render json: MarketVendorSerializer.new(@market_vendor)
  end

  private

  def market_vendor_params
    params.permit(:market_id, :vendor_id)
  end
end
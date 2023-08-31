class Api::V0::MarketVendorsController < ApplicationController
  
  def create
    begin
    @market_vendor = MarketVendor.create!(market_vendor_params)
    render json: MarketVendorSerializer.new(MarketVendor.last), status: 201
    rescue ActiveRecord::RecordInvalid => error
      render json: {
        errors: [
          {
            detail: "#{error.message}"
          }
        ]
      }, status: 404
    end
  end

  def destroy
  
    @market_vendor = MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id])
    if @market_vendor.present?  
    @market_vendor.destroy
      render json: {}, status: 204
    else 
      render json: {
        errors: [
          {
            detail: "Couldn't find MarketVendor with 'id'={\"market_id\"=>#{params[:market_id]}, \"vendor_id\"=>#{params[:vendor_id]}}"
          }
        ]
      }, status: 404
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end
end
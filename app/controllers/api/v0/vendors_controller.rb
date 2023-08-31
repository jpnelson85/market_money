class Api::V0::VendorsController < ApplicationController
  def index
    begin
      render json: VendorSerializer.new(Market.find(params[:market_id]).vendors, status: 200)
    rescue ActiveRecord::RecordNotFound => error
      render json: {
        errors: [
          {
            detail: "Couldn't find Market with 'id'=#{params[:market_id]}"
          }
        ]
      }, status: 404
    end
  end

  def show
    begin
      render json: VendorSerializer.new(Vendor.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => error
      render json: {
        errors: [
          {
            detail: "Couldn't find Vendor with 'id'=#{params[:id]}"
          }
        ]
      }, status: 404
    end
  end

  def create
    begin  
      vendor = Vendor.create!(vendor_params)
      render json: VendorSerializer.new(Vendor.last), status: 201
    rescue ActiveRecord::RecordInvalid => error
      render json: {
        errors: [
          {
            detail: "Validation failed: Contact name can't be blank, Contact phone can't be blank"
          }
        ]
      }, status: 400
    end
  end

  def update
    @vendor = Vendor.find(params[:id])
    @vendor.update(vendor_params)
    render json: VendorSerializer.new(@vendor)
  end

  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end
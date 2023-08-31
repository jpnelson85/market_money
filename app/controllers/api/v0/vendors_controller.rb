class Api::V0::VendorsController < ApplicationController
  def index
    begin
      render json: VendorSerializer.new(Market.find(params[:market_id]).vendors, status: 200)
    rescue ActiveRecord::RecordNotFound => error
      render json: {
        errors: [
          {
            detail: "#{error.message}"
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
            detail: "#{error.message}"
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
            detail: "#{error.message}"
          }
        ]
      }, status: 400
    end
  end

  def update
    begin
      @vendor = Vendor.find(params[:id])
      @vendor.update!(vendor_params)
      render json: VendorSerializer.new(@vendor), status: 200
    rescue ActiveRecord::RecordInvalid => error
      render json: {
        errors: [
          {
            detail: "#{error.message}"
          }
        ]
      }, status: 400
    rescue ActiveRecord::RecordNotFound => error
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
    begin
      @vendor = Vendor.find(params[:id])
      @vendor.destroy
    rescue ActiveRecord::RecordNotFound => error
      render json: {
        errors: [
          {
            detail: "#{error.message}"
          }
        ]
      }, status: 404
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end
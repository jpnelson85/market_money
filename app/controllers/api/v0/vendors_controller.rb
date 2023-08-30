class Api::V0::VendorsController < ApplicationController
  def index
    render json: VendorSerializer.new(Vendor.all)
  end

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    @vendor = Vendor.create(vendor_params)
    @vendor.save
    render json: VendorSerializer.new(@vendor)
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
    params.permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end
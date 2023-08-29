class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    if 
      render json: MarketSerializer.new(Market.find(params[:id]))
    else 
      render json: ErrorMemberSerializer.new(Market.find(params[:id]).serialized_json)
  end

  private

  def market_params
    params.permit(:name, :street, :city, :county, :state, :zip, :lat, :lon)
  end
end
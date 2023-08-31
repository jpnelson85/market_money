class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  # def show
  #   if Market.find(params[:id]).exists?
  #     render json: MarketSerializer.new(Market.find(params[:id]))
  #   else
  #     render json: { message: "Market not found", error: "string", body: "string" } status: :not_found
  #   end
  # end

  def show
    begin
      render json: MarketSerializer.new(Market.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => error
      render json: {
        errors: [
          {
            detail: "Couldn't find Market with 'id'=#{params[:id]}"
          }
        ]
      }, status: 404
    end
  end

  private

  def market_params
    params.permit(:name, :street, :city, :county, :state, :zip, :lat, :lon)
  end
end
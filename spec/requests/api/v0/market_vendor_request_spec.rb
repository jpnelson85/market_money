require "rails_helper"

describe "Market_Vendor API" do
  it "can create a market_vendor" do
    market = create(:market)
    vendor = create(:vendor)
    post "/api/v0/market_vendors", headers: { "CONTENT_TYPE" => "application/json" }, params: JSON.generate({ "market_id": market.id, "vendor_id": vendor.id })
    created_market_vendor = MarketVendor.last

    expect(created_market_vendor.market_id).to eq(market.id)
    expect(created_market_vendor.vendor_id).to eq(vendor.id)

    expect(response).to be_successful
    expect(response.status).to eq(201)

    market_vendor = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(market_vendor).to have_key(:merchant_id)
    expect(market_vendor[:merchant_id]).to be_a(String)

    expect(market_vendor).to have_key(:vendor_id)
    expect(market_vendor[:vendor_id]).to be_a(String)

  # get "api/v0/markets/#{market.id}/vendors"

  # expect
  end

  it "can delete a market_vendor" do
    market = create(:market)
    vendor = create(:vendor)
    market_vendor = create(:market_vendor, market_id: market.id, vendor_id: vendor.id)
    delete "/api/v0/market_vendors", headers: { "CONTENT_TYPE" => "application/json" }, params: JSON.generate({ "market_id": market.id, "vendor_id": vendor.id })

    expect(response).to be_successful
    expect(response.status).to eq(204)

    expect(MarketVendor.all.count).to eq(0)
    expect(Market.all.count).to eq(1)
    expect(Vendor.all.count).to eq(1)
  end
end
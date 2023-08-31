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

    expect(market_vendor).to have_key(:id)
    expect(market_vendor[:id]).to be_a(String)

    expect(market_vendor).to have_key(:type)
    expect(market_vendor[:type]).to be_a(String)

    expect(market_vendor[:attributes]).to have_key(:market_id)
    expect(market_vendor[:attributes][:market_id]).to be_a(Integer)
    
    expect(market_vendor[:attributes]).to have_key(:vendor_id)
    expect(market_vendor[:attributes][:vendor_id]).to be_a(Integer)

    expect(market_vendor[:relationships]).to have_key(:market)
    expect(market_vendor[:relationships][:market]).to be_a(Hash)

    expect(market_vendor[:relationships]).to have_key(:vendor)
    expect(market_vendor[:relationships][:vendor]).to be_a(Hash)
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

  it "errors if market id don't exist when creating market_vendor" do
    vendor = create(:vendor)
    post "/api/v0/market_vendors", headers: { "CONTENT_TYPE" => "application/json" }, params: JSON.generate({ "market_id": 1, "vendor_id": vendor.id })

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:errors)
    expect(data[:errors][0]).to have_key(:detail)
    expect(data[:errors][0][:detail]).to eq("Validation failed: Market must exist")
  end

  it "errors if vendor id don't exist when creating market_vendor" do
    market = create(:market)
    post "/api/v0/market_vendors", headers: { "CONTENT_TYPE" => "application/json" }, params: JSON.generate({ "market_id": market.id, "vendor_id": 1 })

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:errors)
    expect(data[:errors][0]).to have_key(:detail)
    expect(data[:errors][0][:detail]).to eq("Validation failed: Vendor must exist")
  end

  it "errors if market_vendor already exists" do
    create(:market, id: 123)
    create(:vendor, id: 456)
    create(:market_vendor, market_id: 123, vendor_id: 456)

    post "/api/v0/market_vendors", headers: { "CONTENT_TYPE" => "application/json" }, params: JSON.generate({ "market_id": 123, "vendor_id": 456 })

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:errors)
    expect(data[:errors][0]).to have_key(:detail)
    expect(data[:errors][0][:detail]).to eq("Validation failed: Vendor has already been taken")
  end

  it "errors if market_vendor doesn't exist and can't delete" do
    delete "/api/v0/market_vendors", headers: { "CONTENT_TYPE" => "application/json" }, params: JSON.generate({ "market_id": 123, "vendor_id": 456 })

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:errors)
    expect(data[:errors][0]).to have_key(:detail)
    expect(data[:errors][0][:detail]).to eq("Couldn't find MarketVendor with 'id'={\"market_id\"=>123, \"vendor_id\"=>456}")
  end
end
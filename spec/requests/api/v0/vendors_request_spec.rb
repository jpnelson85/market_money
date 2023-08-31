require "rails_helper"

describe "Vendors API" do
  it "sends a list of vendors" do
    id = create(:market).id
    create_list(:vendor, 3)

    get "/api/v0/markets/#{id}/vendors"

    expect(response).to be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)[:data]

    vendors.each do |vendor|
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)

      expect(vendor).to have_key(:attributes)
      expect(vendor[:attributes]).to be_a(Hash)

      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to be_in([true, false])
      
    end
  end

  it "can get one vendor by its id" do
    id = create(:vendor).id

    get "/api/v0/vendors/#{id}"

    expect(response).to be_successful

    vendor = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(vendor).to have_key(:id)
    expect(vendor[:id]).to be_a(String)

    expect(vendor).to have_key(:attributes)
    expect(vendor[:attributes]).to be_a(Hash)

    expect(vendor[:attributes]).to have_key(:name)
    expect(vendor[:attributes][:name]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:description)
    expect(vendor[:attributes][:description]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:contact_name)
    expect(vendor[:attributes][:contact_name]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:contact_phone)
    expect(vendor[:attributes][:contact_phone]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:credit_accepted)
    expect(vendor[:attributes][:credit_accepted]).to be_in([true, false])
  end

  it "can create a new vendor" do
    
    post "/api/v0/vendors", headers: {"CONTENT_TYPE" => "application/json"}, params: ({name: "Test Vendor", description: "Test Description", contact_name: "Test Contact", contact_phone: "Test Phone", credit_accepted: true}).to_json
    created_vendor = Vendor.last

    expect(created_vendor.name).to eq("Test Vendor")
    expect(created_vendor.description).to eq("Test Description")
    expect(created_vendor.contact_name).to eq("Test Contact")
    expect(created_vendor.contact_phone).to eq("Test Phone")
    expect(created_vendor.credit_accepted).to eq(true)
    expect(response).to be_successful
    expect(response.status).to eq(201)

    vendor = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(vendor).to have_key(:id)
    expect(vendor[:id]).to be_a(String)

    expect(vendor).to have_key(:type)
    expect(vendor[:type]).to eq("vendor")

    expect(vendor[:attributes]).to have_key(:name)
    expect(vendor[:attributes][:name]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:description)
    expect(vendor[:attributes][:description]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:contact_name)
    expect(vendor[:attributes][:contact_name]).to be_a(String) 

    expect(vendor[:attributes]).to have_key(:contact_phone)
    expect(vendor[:attributes][:contact_phone]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:credit_accepted)
    expect(vendor[:attributes][:credit_accepted]).to be_in([true, false])
  end

  it "can update an existing vendor" do
    existing_vendor = create(:vendor, name: "Old Name", description: "Old Description", contact_name: "Old Contact", contact_phone: "Old Phone", credit_accepted: false)
    patch "/api/v0/vendors/#{existing_vendor.id}", headers: {"CONTENT_TYPE" => "application/json"}, params: ({name: "Test Vendor", description: "Test Description", contact_name: "Test Contact", contact_phone: "Test Phone", credit_accepted: true}).to_json

    expect(response).to be_successful

    vendor = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(vendor).to have_key(:id)
    expect(vendor[:id]).to be_a(String)

    expect(vendor).to have_key(:type)
    expect(vendor[:type]).to eq("vendor")

    expect(vendor[:attributes]).to have_key(:name)
    expect(vendor[:attributes][:name]).to eq("Test Vendor")
    
    expect(vendor[:attributes]).to have_key(:description)
    expect(vendor[:attributes][:description]).to eq("Test Description")

    expect(vendor[:attributes]).to have_key(:contact_name)
    expect(vendor[:attributes][:contact_name]).to eq("Test Contact")

    expect(vendor[:attributes]).to have_key(:contact_phone)
    expect(vendor[:attributes][:contact_phone]).to eq("Test Phone")

    expect(vendor[:attributes]).to have_key(:credit_accepted)
    expect(vendor[:attributes][:credit_accepted]).to eq(true)
  end

  it "can delete an existing vendor and market_vendor" do
    existing_vendor = create(:vendor)
    create(:market_vendor, vendor_id: existing_vendor.id)
    expect(Vendor.all.count).to eq(1)
    expect(MarketVendor.all.count).to eq(1)
    expect(Market.all.count).to eq(1)
    delete "/api/v0/vendors/#{existing_vendor.id}"

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(Vendor.all.count).to eq(0)
    expect(MarketVendor.all.count).to eq(0)
    expect(Market.all.count).to eq(1)
  end

  it "displays error message if invalid market id" do

    get "/api/v0/markets/123123123123123123123123/vendors"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:errors)
    expect(data[:errors][0]).to have_key(:detail)
    expect(data[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=123123123123123123123123")
  end

  it "displays error message if invalid vendor id" do

    get "/api/v0/vendors/123123123123123123123123/"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:errors)
    expect(data[:errors][0]).to have_key(:detail)
    expect(data[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=123123123123123123123123")
  end

  it "displays error if vendor can't be created" do

    post "/api/v0/vendors", headers: {"CONTENT_TYPE" => "application/json"}, params: ({name: "Test Vendor", description: "Test Description", credit_accepted: true}).to_json
    
    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:errors)
    expect(data[:errors][0]).to have_key(:detail)
    expect(data[:errors][0][:detail]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
  end
end
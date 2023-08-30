require 'rails_helper'

RSpec.describe Market, type: :model do
  describe "relationships" do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "instance methods" do
    it "#vendor_count" do
    @market1 = create(:market)
    @market2 = create(:market)
    @vendor1 = create(:vendor)
    @vendor2 = create(:vendor)
    @vendor3 = create(:vendor)
    create_list(:market_vendor, 2, market_id: @market1.id)
    create_list(:market_vendor, 3, market_id: @market2.id)
      expect(@market1.vendor_count).to eq(2)
      expect(@market2.vendor_count).to eq(3)
    end
  end
end

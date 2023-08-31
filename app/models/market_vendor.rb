class MarketVendor < ApplicationRecord
  validates :vendor_id, uniqueness: { scope: :market_id }
  belongs_to :market
  belongs_to :vendor
end
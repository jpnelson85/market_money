class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def number_of_vendors
    self.vendors.count
  end
end

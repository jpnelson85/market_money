class Vendor < ApplicationRecord
  has_many :market_vendors, depdendent: :destroy
  has_many :markets, through: :market_vendors

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :contact_name
  validates_presence_of :contact_phone
  validates_inclusion_of :credit_accepted, in: [true, false]
end
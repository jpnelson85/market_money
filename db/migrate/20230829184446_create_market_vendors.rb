class CreateMarketVendors < ActiveRecord::Migration[7.0]
  def change
    create_table :market_vendors do |t|
      t.references :vendor, foreign_key: true
      t.references :market, foreign_key: true

      t.timestamps
    end
  end
end

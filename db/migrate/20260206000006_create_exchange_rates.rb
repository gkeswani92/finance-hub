# typed: false
# frozen_string_literal: true

class CreateExchangeRates < ActiveRecord::Migration[8.0]
  def change
    create_table :exchange_rates do |t|
      t.string :base_currency, null: false
      t.string :target_currency, null: false
      t.decimal :rate, precision: 15, scale: 6, null: false
      t.date :rate_date, null: false
      t.string :source
      t.datetime :fetched_at

      t.timestamps
    end

    add_index :exchange_rates, [:base_currency, :target_currency, :rate_date],
      unique: true, name: "index_exchange_rates_on_currencies_and_date"
  end
end

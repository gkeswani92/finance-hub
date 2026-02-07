# typed: false
# frozen_string_literal: true

require "net/http"
require "json"

namespace :fx do
  desc "Fetch current USD/INR exchange rate and store it"
  task fetch: :environment do
    today = Date.current

    if ExchangeRate.exists?(base_currency: "USD", target_currency: "INR", rate_date: today)
      puts "USD/INR rate for #{today} already cached, skipping."
      next
    end

    rate = nil
    source = nil

    # Primary: Frankfurter API
    begin
      uri = URI("https://api.frankfurter.dev/v1/latest?base=USD&symbols=INR")
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
      rate = data.dig("rates", "INR")
      source = "frankfurter" if rate
    rescue => e
      puts "Frankfurter API failed: #{e.message}"
    end

    # Fallback: ExchangeRate-API
    unless rate
      begin
        uri = URI("https://open.er-api.com/v6/latest/USD")
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        rate = data.dig("rates", "INR")
        source = "exchangerate-api" if rate
      rescue => e
        puts "ExchangeRate-API failed: #{e.message}"
      end
    end

    unless rate
      abort("Could not fetch USD/INR rate from any source.")
    end

    ExchangeRate.create!(
      base_currency: "USD",
      target_currency: "INR",
      rate: rate,
      rate_date: today,
      source: source,
      fetched_at: Time.current,
    )

    puts "Stored USD/INR rate: #{rate} (source: #{source})"
  end
end

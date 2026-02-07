# typed: false
# frozen_string_literal: true

require "json"

namespace :projectionlab do
  desc "Import historical snapshots from ProjectionLab JSON export"
  task import_history: :environment do
    file = ENV["FILE"] || File.expand_path("~/Downloads/2026-02-06-projectionlab-account-data--gauravkeswani92-at-gmail-com.json")
    abort("File not found: #{file}") unless File.exist?(file)

    data = JSON.parse(File.read(file))
    progress = data.dig("progress", "data")
    abort("No progress data found") if progress.nil? || progress.empty?

    # ProjectionLab category → Rails category names
    category_mapping = {
      "savings" => ["Cash"],
      "taxable" => ["Taxable", "Angel Investments", "PMS & AIF"],
      "taxDeferred" => ["Retirement"],
      "crypto" => ["Crypto"],
      "taxFree" => ["Tax Free"],
      "assets" => ["Other Assets"],
      "debt" => ["Credit Cards"],
    }

    # Load accounts grouped by Rails category
    accounts_by_group = {}
    category_mapping.each do |pl_key, cat_names|
      accts = Account.active.includes(:category).select { |a| cat_names.include?(a.category.name) }
      accounts_by_group[pl_key] = accts
    end

    existing_dates = ValueSnapshot.distinct.pluck(:snapshot_date).to_set
    created = 0

    progress.each do |entry|
      date = Time.at(entry["date"] / 1000).to_date
      next if existing_dates.include?(date)

      category_mapping.each_key do |pl_key|
        total = entry[pl_key]&.to_f || 0.0
        accts = accounts_by_group[pl_key]
        next if accts.empty? || total.zero?

        current_total = accts.sum(&:latest_value_usd).to_f
        next if current_total.zero?

        accts.each do |account|
          proportion = account.latest_value_usd.to_f / current_total
          # Store in account's native currency for INR accounts
          value = if account.currency == "INR"
            fx_rate = ExchangeRate.latest("USD", "INR")&.rate || 85.0
            (total * proportion * fx_rate).round(2)
          else
            (total * proportion).round(2)
          end

          ValueSnapshot.create!(account_id: account.id, snapshot_date: date, value: value)
          created += 1
        end
      end
    end

    puts "Created #{created} historical snapshots across #{progress.size} dates"
    puts "Total snapshots now: #{ValueSnapshot.count}"
  end
end

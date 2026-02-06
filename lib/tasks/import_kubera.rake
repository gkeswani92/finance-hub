# typed: false
# frozen_string_literal: true

require "json"

namespace :kubera do
  desc "Import accounts from Kubera JSON export"
  task import: :environment do
    file = ENV["FILE"] || File.expand_path("~/Downloads/Gaurav Keswani.json")
    abort("File not found: #{file}") unless File.exist?(file)

    data = JSON.parse(File.read(file))
    today = Date.current

    # Map Kubera sheet names to owners
    owner_map = {}
    Owner.find_each { |o| owner_map[o.name] = o }

    # Map Kubera section names to categories, creating missing ones
    category_map = {}
    Category.find_each { |c| category_map[c.name] = c }

    kubera_section_mapping = {
      "Taxable" => "Taxable",
      "Retirement" => "Retirement",
      "PMS & AIF" => "PMS & AIF",
      "Cryptocurrency" => "Crypto",
      "Angel Investments" => "Angel Investments",
      "Employer RSU" => "Taxable",
      "Tax free" => "Tax Free",
      "INR" => "Cash",
      "USD" => "Cash",
      "Section 1" => "Other Assets",
    }

    # Debt-specific: sheet "Credit Card" with section "Section 1" → Credit Cards
    kubera_debt_mapping = {
      "Credit Card" => "Credit Cards",
    }

    # Create any missing categories
    new_categories = {
      "Angel Investments" => { display_order: 8, is_debt: false },
      "Tax Free" => { display_order: 9, is_debt: false },
    }
    new_categories.each do |name, attrs|
      category_map[name] ||= Category.find_or_create_by!(name: name) do |c|
        c.display_order = attrs[:display_order]
        c.is_debt = attrs[:is_debt]
      end
    end

    # Map special sheet names to owners
    owner_map["Metals"] ||= Owner.find_or_create_by!(name: "Joint")
    owner_map["Credit Card"] = owner_map["Joint"]
    owner_map["Cash"] = owner_map["Joint"]

    # Seed exchange rate (USD/INR)
    require "net/http"
    begin
      uri = URI("https://api.frankfurter.dev/v1/latest?base=USD&symbols=INR")
      response = Net::HTTP.get(uri)
      fx_data = JSON.parse(response)
      inr_rate = fx_data.dig("rates", "INR")
      if inr_rate
        ExchangeRate.find_or_create_by!(
          base_currency: "USD",
          target_currency: "INR",
          rate_date: Date.current,
        ) do |er|
          er.rate = inr_rate
          er.source = "frankfurter"
          er.fetched_at = Time.current
        end
        puts "Fetched USD/INR rate: #{inr_rate}"
      end
    rescue => e
      puts "Warning: Could not fetch exchange rate: #{e.message}"
      inr_rate = 85.0
    end

    # Aggregate holdings into parent accounts
    parents = {}

    (data["asset"] || []).each do |item|
      parent = item["parent"]
      if parent
        pid = parent["id"]
        parents[pid] ||= {
          name: parent["name"],
          section: item["sectionName"],
          sheet: item["sheetName"],
          currency: item.dig("value", "currency") || "USD",
          institution: item.dig("connection", "providerName") || "",
          total_value: 0.0,
          total_cost: 0.0,
        }
        parents[pid][:total_value] += item.dig("value", "amount") || 0
        parents[pid][:total_cost] += item.dig("cost", "amount") || 0 if item["cost"]
      else
        aid = item["id"]
        parents[aid] ||= {
          name: item["name"],
          section: item["sectionName"],
          sheet: item["sheetName"],
          currency: item.dig("value", "currency") || "USD",
          institution: item.dig("connection", "providerName") || "",
          total_value: item.dig("value", "amount") || 0,
          total_cost: item.dig("cost", "amount") || 0,
        }
      end
    end

    # Process debts
    (data["debt"] || []).each do |item|
      aid = item["id"]
      parents[aid] ||= {
        name: item["name"],
        section: item["sectionName"],
        sheet: item["sheetName"],
        currency: item.dig("value", "currency") || "USD",
        institution: item.dig("connection", "providerName") || "",
        total_value: item.dig("value", "amount") || 0,
        total_cost: 0.0,
        is_debt: true,
      }
    end

    created = 0
    skipped = 0

    parents.each do |_pid, p|
      # Resolve owner
      sheet = p[:sheet]
      owner = if %w[Gaurav Priyanka Joint Cash Metals].include?(sheet)
        owner_map[sheet == "Cash" || sheet == "Metals" ? "Joint" : sheet]
      else
        owner_map["Joint"]
      end

      unless owner
        puts "  SKIP (no owner): #{p[:name]} (sheet: #{sheet})"
        skipped += 1
        next
      end

      # Resolve category
      section = p[:section]
      cat_name = if p[:is_debt] && kubera_debt_mapping[p[:sheet]]
        kubera_debt_mapping[p[:sheet]]
      else
        kubera_section_mapping[section] || section
      end
      category = category_map[cat_name]

      unless category
        # Auto-create missing category
        max_order = Category.maximum(:display_order) || 0
        category = Category.create!(
          name: cat_name,
          display_order: max_order + 1,
          is_debt: p[:is_debt] || false,
        )
        category_map[cat_name] = category
        puts "  Created category: #{cat_name}"
      end

      # Create or find account
      account = Account.find_or_initialize_by(name: p[:name], owner: owner)
      account.assign_attributes(
        category: category,
        institution: p[:institution].presence,
        currency: p[:currency],
        cost_basis: p[:total_cost] > 0 ? p[:total_cost].round(2) : nil,
        is_active: true,
      )
      account.save!

      # Create today's value snapshot
      account.value_snapshots.find_or_create_by!(snapshot_date: today) do |s|
        s.value = p[:total_value].round(2)
      end

      created += 1
      puts "  #{account.name}: #{p[:currency]} #{p[:total_value].round(2)}"
    end

    puts
    puts "Done: #{created} accounts imported, #{skipped} skipped"
    puts "Total accounts: #{Account.count}"
  end
end

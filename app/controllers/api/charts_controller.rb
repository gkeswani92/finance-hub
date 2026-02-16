# typed: false
# frozen_string_literal: true

module Api
  class ChartsController < ApplicationController
    def net_worth_history
      dates = ValueSnapshot.distinct.pluck(:snapshot_date).sort
      fx_rate = ExchangeRate.latest("USD", "INR")&.rate || 85.0
      accounts = Account.includes(:category, :value_snapshots)

      data = dates.map do |date|
        assets = 0.0
        debts = 0.0

        accounts.each do |account|
          snapshot = account.value_snapshots.select { |s| s.snapshot_date <= date }.max_by(&:snapshot_date)
          next unless snapshot

          value = snapshot.value.to_f
          value /= fx_rate if account.currency == "INR"

          if account.debt?
            debts += value
          else
            assets += value
          end
        end

        { date: date.to_s, assets: assets, debts: debts, net_worth: assets - debts }
      end

      render(json: data)
    end

    def sankey_data
      accounts = Account.active.includes(:category, :member, :value_snapshots)
      nodes = []
      links = []
      node_set = Set.new

      accounts.each do |account|
        value = account.latest_value_usd.to_f
        next if value.zero?

        category_name = account.category.name
        member_name = account.member.name
        bucket = account.debt? ? "Debts" : "Assets"

        [category_name, member_name, bucket, "Net Worth"].each do |n|
          unless node_set.include?(n)
            nodes << { name: n }
            node_set.add(n)
          end
        end

        links << { source: category_name, target: member_name, value: value }
        links << { source: member_name, target: bucket, value: value }
      end

      aggregated = links.group_by { |l| [l[:source], l[:target]] }.map do |key, group|
        { source: key[0], target: key[1], value: group.sum { |l| l[:value] } }
      end

      total_assets = accounts.reject(&:debt?).sum { |a| a.latest_value_usd.to_f }
      total_debts = accounts.select(&:debt?).sum { |a| a.latest_value_usd.to_f }

      aggregated << { source: "Assets", target: "Net Worth", value: total_assets } if total_assets > 0
      aggregated << { source: "Debts", target: "Net Worth", value: total_debts } if total_debts > 0

      render(json: { nodes: nodes, links: aggregated })
    end

    def allocation_by_asset_type
      accounts = Account.active.includes(:category, :value_snapshots).reject(&:debt?)
      data = accounts.group_by(&:category).map do |category, accts|
        { name: category.name, value: accts.sum(&:latest_value_usd).to_f }
      end.select { |d| d[:value] > 0 }.sort_by { |d| -d[:value] }

      render(json: data)
    end

    def allocation_by_member
      accounts = Account.active.includes(:member, :value_snapshots).reject(&:debt?)
      data = accounts.group_by(&:member).map do |member, accts|
        { name: member.name, value: accts.sum(&:latest_value_usd).to_f, color: member.color }
      end.select { |d| d[:value] > 0 }.sort_by { |d| -d[:value] }

      render(json: data)
    end

    def allocation_by_currency
      accounts = Account.active.includes(:value_snapshots).reject { |a| a.debt? }
      data = accounts.group_by(&:currency).map do |currency, accts|
        { name: currency, value: accts.sum(&:latest_value_usd).to_f }
      end.select { |d| d[:value] > 0 }.sort_by { |d| -d[:value] }

      render(json: data)
    end
  end
end

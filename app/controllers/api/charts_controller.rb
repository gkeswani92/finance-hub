# typed: false
# frozen_string_literal: true

module Api
  class ChartsController < ApplicationController
    def net_worth_history
      dates = ValueSnapshot.distinct.pluck(:snapshot_date).sort
      fx_rate = ExchangeRate.latest("USD", "INR")&.rate || 85.0
      accounts = Account.active.includes(:category, :value_snapshots)

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
      accounts = Account.active.includes(:category, :owner, :value_snapshots)
      nodes = []
      links = []
      node_set = Set.new

      # Flow: Category → Owner → Assets/Debts → Net Worth
      accounts.each do |account|
        value = account.latest_value_usd.to_f
        next if value.zero?

        category_name = account.category.name
        owner_name = account.owner.name
        bucket = account.debt? ? "Debts" : "Assets"

        [category_name, owner_name, bucket, "Net Worth"].each do |n|
          unless node_set.include?(n)
            nodes << { name: n }
            node_set.add(n)
          end
        end

        links << { source: category_name, target: owner_name, value: value }
        links << { source: owner_name, target: bucket, value: value }
      end

      # Aggregate links (same source+target)
      aggregated = links.group_by { |l| [l[:source], l[:target]] }.map do |key, group|
        { source: key[0], target: key[1], value: group.sum { |l| l[:value] } }
      end

      # Final bucket → Net Worth
      total_assets = accounts.reject(&:debt?).sum { |a| a.latest_value_usd.to_f }
      total_debts = accounts.select(&:debt?).sum { |a| a.latest_value_usd.to_f }

      aggregated << { source: "Assets", target: "Net Worth", value: total_assets } if total_assets > 0
      aggregated << { source: "Debts", target: "Net Worth", value: total_debts } if total_debts > 0

      render(json: { nodes: nodes, links: aggregated })
    end
  end
end

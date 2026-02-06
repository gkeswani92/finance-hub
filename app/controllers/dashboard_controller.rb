# typed: false
# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @accounts = Account.active.includes(:category, :owner, :value_snapshots)

    @total_assets = @accounts.reject(&:debt?).sum(&:latest_value_usd)
    @total_debts = @accounts.select(&:debt?).sum(&:latest_value_usd)
    @net_worth = @total_assets - @total_debts

    @one_day_change = net_worth_change(1.day.ago.to_date)
    @one_month_change = net_worth_change(1.month.ago.to_date)
  end

  private

  def net_worth_change(as_of_date)
    fx_rate = ExchangeRate.latest("USD", "INR")&.rate || 85.0

    accounts = Account.active.includes(:category, :value_snapshots)
    total = accounts.sum do |account|
      snapshot = account.value_snapshots.select { |s| s.snapshot_date <= as_of_date }.max_by(&:snapshot_date)
      value = snapshot&.value || 0
      value /= fx_rate if account.currency == "INR" && value > 0
      account.debt? ? -value : value
    end

    return 0 if total.zero?

    @net_worth - total
  end
end

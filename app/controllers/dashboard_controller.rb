# typed: false
# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @accounts = Account.active.includes(:category, :member, :value_snapshots)

    @total_assets = @accounts.reject(&:debt?).sum(&:latest_value_usd)
    @total_debts = @accounts.select(&:debt?).sum(&:latest_value_usd)
    @net_worth = @total_assets - @total_debts

    # Investable = total assets minus illiquid assets
    illiquid = @accounts.reject(&:debt?).select { |a| a.category && !a.category.is_liquid? }.sum(&:latest_value_usd)
    @investable = @total_assets - illiquid

    @one_day_change = net_worth_change(1.day.ago.to_date)
    @one_month_change = net_worth_change(1.month.ago.to_date)

    prev_nw_1d = @net_worth - @one_day_change
    prev_nw_1m = @net_worth - @one_month_change
    @one_day_change_pct = prev_nw_1d.zero? ? 0 : (@one_day_change / prev_nw_1d * 100)
    @one_month_change_pct = prev_nw_1m.zero? ? 0 : (@one_month_change / prev_nw_1m * 100)
  end

  private

  def net_worth_change(as_of_date)
    fx_rate = ExchangeRate.latest("USD", "INR")&.rate || 85.0

    accounts = Account.includes(:category, :value_snapshots)
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

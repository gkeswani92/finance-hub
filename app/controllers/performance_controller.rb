# typed: false
# frozen_string_literal: true

class PerformanceController < ApplicationController
  def index
    ExchangeRate.latest("USD", "INR")&.rate || 85.0

    @accounts = Account.active.includes(:category, :member, :value_snapshots)
      .reject(&:debt?)
      .select { |a| a.cost_basis.present? && a.cost_basis > 0 }
      .sort_by { |a| -a.latest_value_usd.to_f }

    @benchmarks = BenchmarkValue.all.group_by(&:benchmark_name).map do |name, values|
      sorted = values.sort_by(&:date)
      sorted.last
      {
        name: name,
        cagr_1y: benchmark_cagr(sorted, 1),
        cagr_3y: benchmark_cagr(sorted, 3),
        cagr_5y: benchmark_cagr(sorted, 5),
      }
    end
  end

  private

  def benchmark_cagr(values, years)
    return if values.size < 2

    latest = values.last
    cutoff_date = latest.date - years.years
    earliest = values.select { |v| v.date <= cutoff_date }.last
    return unless earliest && earliest.value > 0

    days = (latest.date - earliest.date).to_f
    return if days < 365

    ((latest.value / earliest.value)**(365.0 / days)) - 1
  end
end

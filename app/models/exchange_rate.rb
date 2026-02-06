# typed: false
# frozen_string_literal: true

class ExchangeRate < ApplicationRecord
  validates :base_currency, presence: true
  validates :target_currency, presence: true
  validates :rate, presence: true, numericality: { greater_than: 0 }
  validates :rate_date, presence: true, uniqueness: { scope: [:base_currency, :target_currency] }

  def self.latest(base = "USD", target = "INR")
    where(base_currency: base, target_currency: target)
      .order(rate_date: :desc)
      .first
  end
end

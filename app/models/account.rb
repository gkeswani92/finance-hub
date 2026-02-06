# typed: false
# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :owner
  belongs_to :category
  has_many :value_snapshots, dependent: :destroy
  has_many :cash_flows, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :owner_id }
  validates :currency, presence: true, inclusion: { in: ["USD", "INR"] }

  scope :active, -> { where(is_active: true) }
  scope :by_category, -> { includes(:category).order("categories.display_order") }

  def latest_snapshot
    value_snapshots.order(snapshot_date: :desc).first
  end

  def latest_value
    latest_snapshot&.value || 0
  end

  def latest_value_usd
    val = latest_value
    return val if currency == "USD" || val.zero?

    fx_rate = ExchangeRate.latest("USD", "INR")&.rate || 85.0
    val / fx_rate
  end

  def debt?
    category&.is_debt?
  end
end

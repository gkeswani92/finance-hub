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

  def first_snapshot_date
    value_snapshots.minimum(:snapshot_date)
  end

  def cagr
    return if cost_basis.nil? || cost_basis.zero?

    current = latest_value
    return if current.zero?

    start_date = first_snapshot_date
    return unless start_date

    days = (Date.current - start_date).to_f
    return if days < 1

    ((current / cost_basis)**(365.0 / days)) - 1
  end

  def cagr_display
    rate = cagr
    return "—" unless rate

    format("%+.1f%%", rate * 100)
  end

  def debt?
    category&.is_debt?
  end
end

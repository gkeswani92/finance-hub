# typed: false
# frozen_string_literal: true

class CashFlow < ApplicationRecord
  belongs_to :account

  FLOW_TYPES = %w[deposit withdrawal dividend].freeze

  validates :flow_date, presence: true
  validates :amount, presence: true, numericality: true
  validates :flow_type, presence: true, inclusion: { in: FLOW_TYPES }
end

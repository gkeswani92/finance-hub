# typed: false
# frozen_string_literal: true

class ValueSnapshot < ApplicationRecord
  belongs_to :account

  validates :snapshot_date, presence: true, uniqueness: { scope: :account_id }
  validates :value, presence: true, numericality: true
end

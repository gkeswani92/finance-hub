# typed: false
# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :accounts, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:display_order) }
  scope :assets, -> { where(is_debt: false) }
  scope :debts, -> { where(is_debt: true) }
end

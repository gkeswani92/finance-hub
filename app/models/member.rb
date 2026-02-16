# typed: false
# frozen_string_literal: true

class Member < ApplicationRecord
  belongs_to :family, optional: true
  has_many :accounts, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :member_type, inclusion: { in: ["individual", "joint", "trust"] }

  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(:display_order) }
end

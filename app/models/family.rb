# typed: false
# frozen_string_literal: true

class Family < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :profiles, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :milestones, dependent: :destroy

  validates :name, presence: true
  validates :invite_code, presence: true, uniqueness: true
  validates :base_currency, presence: true, inclusion: { in: ["USD", "INR"] }
end

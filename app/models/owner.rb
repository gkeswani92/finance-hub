# typed: false
# frozen_string_literal: true

class Owner < ApplicationRecord
  has_many :accounts, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end

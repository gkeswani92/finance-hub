# typed: false
# frozen_string_literal: true

class Milestone < ApplicationRecord
  belongs_to :family
  belongs_to :member, optional: true

  validates :milestone_type, presence: true
  validates :target_value, presence: true, numericality: true
end

# typed: false
# frozen_string_literal: true

class BenchmarkValue < ApplicationRecord
  validates :benchmark_name, presence: true
  validates :date, presence: true, uniqueness: { scope: :benchmark_name }
  validates :value, presence: true, numericality: true
end

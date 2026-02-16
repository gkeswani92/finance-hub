# typed: false
# frozen_string_literal: true

class EnhanceCategories < ActiveRecord::Migration[8.0]
  def change
    add_reference(:categories, :family, foreign_key: true)
    add_column(:categories, :is_liquid, :boolean, null: false, default: true)
    add_column(:categories, :icon, :string, null: false, default: "wallet")
  end
end

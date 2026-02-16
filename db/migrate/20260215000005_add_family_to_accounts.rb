# typed: false
# frozen_string_literal: true

class AddFamilyToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_reference(:accounts, :family, foreign_key: true)
  end
end

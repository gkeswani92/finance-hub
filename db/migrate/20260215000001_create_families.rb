# typed: false
# frozen_string_literal: true

class CreateFamilies < ActiveRecord::Migration[8.0]
  def change
    create_table(:families) do |t|
      t.string(:name, null: false)
      t.string(:created_by, null: false)
      t.string(:invite_code, null: false)
      t.string(:base_currency, null: false, default: "USD")
      t.timestamps
    end

    add_index(:families, :invite_code, unique: true)
  end
end

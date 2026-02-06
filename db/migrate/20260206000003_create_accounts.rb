# typed: false
# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.references :owner, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :institution
      t.string :currency, null: false, default: "USD"
      t.decimal :cost_basis, precision: 15, scale: 2
      t.boolean :is_active, default: true, null: false
      t.text :notes

      t.timestamps
    end

    add_index :accounts, [:owner_id, :name], unique: true
  end
end

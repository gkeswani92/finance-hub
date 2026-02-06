# typed: false
# frozen_string_literal: true

class CreateCashFlows < ActiveRecord::Migration[8.0]
  def change
    create_table :cash_flows do |t|
      t.references :account, null: false, foreign_key: true
      t.date :flow_date, null: false
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.string :flow_type, null: false
      t.text :notes

      t.timestamps
    end

    add_index :cash_flows, [:account_id, :flow_date]
  end
end

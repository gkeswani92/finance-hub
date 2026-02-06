# typed: false
# frozen_string_literal: true

class CreateValueSnapshots < ActiveRecord::Migration[8.0]
  def change
    create_table :value_snapshots do |t|
      t.references :account, null: false, foreign_key: true
      t.date :snapshot_date, null: false
      t.decimal :value, precision: 15, scale: 2, null: false

      t.timestamps
    end

    add_index :value_snapshots, [:account_id, :snapshot_date], unique: true
    add_index :value_snapshots, :snapshot_date
  end
end

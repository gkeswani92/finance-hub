# typed: false
# frozen_string_literal: true

class CreateBenchmarkValues < ActiveRecord::Migration[8.0]
  def change
    create_table(:benchmark_values) do |t|
      t.string(:benchmark_name, null: false)
      t.date(:date, null: false)
      t.decimal(:value, precision: 15, scale: 2, null: false)
      t.timestamps
    end

    add_index(:benchmark_values, [:benchmark_name, :date], unique: true)
  end
end

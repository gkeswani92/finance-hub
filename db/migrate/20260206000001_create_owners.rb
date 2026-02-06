# typed: false
# frozen_string_literal: true

class CreateOwners < ActiveRecord::Migration[8.0]
  def change
    create_table :owners do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :owners, :name, unique: true
  end
end

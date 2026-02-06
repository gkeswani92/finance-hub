# typed: false
# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.integer :display_order, default: 0, null: false
      t.boolean :is_debt, default: false, null: false

      t.timestamps
    end

    add_index :categories, :name, unique: true
    add_index :categories, :display_order
  end
end

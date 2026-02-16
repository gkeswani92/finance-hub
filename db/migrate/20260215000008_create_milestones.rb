# typed: false
# frozen_string_literal: true

class CreateMilestones < ActiveRecord::Migration[8.0]
  def change
    create_table(:milestones) do |t|
      t.references(:family, null: false, foreign_key: true)
      t.string(:milestone_type, null: false)
      t.references(:member, foreign_key: true)
      t.decimal(:target_value, precision: 15, scale: 2, null: false)
      t.date(:reached_date)
      t.string(:currency, null: false, default: "USD")
      t.timestamps
    end

    add_index(
      :milestones,
      [:family_id, :milestone_type, :member_id, :target_value],
      unique: true,
      name: "idx_milestones_unique",
    )
  end
end

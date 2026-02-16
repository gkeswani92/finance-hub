# typed: false
# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table(:profiles) do |t|
      t.string(:user_id, null: false)
      t.string(:email)
      t.string(:full_name)
      t.references(:family, foreign_key: true)
      t.string(:family_role, null: false, default: "member")
      t.boolean(:is_admin, null: false, default: false)
      t.timestamps
    end

    add_index(:profiles, :user_id, unique: true)
  end
end

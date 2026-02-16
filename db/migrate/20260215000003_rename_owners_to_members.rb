# typed: false
# frozen_string_literal: true

class RenameOwnersToMembers < ActiveRecord::Migration[8.0]
  def up
    rename_table(:owners, :members)

    add_reference(:members, :family, foreign_key: true)
    add_column(:members, :member_type, :string, null: false, default: "individual")
    add_column(:members, :color, :string, null: false, default: "#7c3aed")
    add_column(:members, :is_active, :boolean, null: false, default: true)
    add_column(:members, :display_order, :integer, null: false, default: 0)

    # Drop the composite unique index before renaming the column,
    # because rename_column will try to auto-create a new one
    remove_index(:accounts, name: "index_accounts_on_owner_id_and_name")
    rename_column(:accounts, :owner_id, :member_id)
  end

  def down
    rename_column(:accounts, :member_id, :owner_id)
    add_index(:accounts, [:owner_id, :name], unique: true, name: "index_accounts_on_owner_id_and_name")

    remove_column(:members, :display_order)
    remove_column(:members, :is_active)
    remove_column(:members, :color)
    remove_column(:members, :member_type)
    remove_reference(:members, :family)

    rename_table(:members, :owners)
  end
end

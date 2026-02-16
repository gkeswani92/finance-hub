# typed: false
# frozen_string_literal: true

class SeedDefaultFamily < ActiveRecord::Migration[8.0]
  def up
    execute("INSERT INTO families (name, created_by, invite_code, base_currency, created_at, updated_at) VALUES ('My Family', 'system', '#{SecureRandom.hex(6)}', 'USD', NOW(), NOW())")
    family_id = ActiveRecord::Base.connection.select_value("SELECT id FROM families ORDER BY id DESC LIMIT 1")

    execute("UPDATE members SET family_id = #{family_id} WHERE family_id IS NULL")
    execute("UPDATE categories SET family_id = #{family_id} WHERE family_id IS NULL")
    execute("UPDATE accounts SET family_id = #{family_id} WHERE family_id IS NULL")
  end

  def down
    # No-op — data migration
  end
end

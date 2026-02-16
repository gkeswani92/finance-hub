# typed: false
# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table(:notifications) do |t|
      t.references(:family, null: false, foreign_key: true)
      t.string(:notification_type, null: false)
      t.string(:title, null: false)
      t.text(:body)
      t.json(:data)
      t.boolean(:is_read, null: false, default: false)
      t.timestamps
    end

    add_index(:notifications, [:family_id, :is_read])
  end
end

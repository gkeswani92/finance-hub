# typed: false
# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :family, optional: true

  validates :user_id, presence: true, uniqueness: true
  validates :family_role, inclusion: { in: ["admin", "member"] }
end

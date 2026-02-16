# typed: false
# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :family

  validates :notification_type, presence: true
  validates :title, presence: true

  scope :unread, -> { where(is_read: false) }
  scope :recent, -> { order(created_at: :desc).limit(20) }
end

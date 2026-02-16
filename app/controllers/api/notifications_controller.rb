# typed: false
# frozen_string_literal: true

module Api
  class NotificationsController < ApplicationController
    def index
      notifications = Notification.recent
      render(json: notifications.map do |n|
        {
          id: n.id,
          type: n.notification_type,
          title: n.title,
          body: n.body,
          is_read: n.is_read,
          created_at: n.created_at,
        }
      end)
    end

    def mark_read
      notification = Notification.find(params[:id])
      notification.update!(is_read: true)
      head(:ok)
    end

    def mark_all_read
      Notification.unread.update_all(is_read: true)
      head(:ok)
    end
  end
end

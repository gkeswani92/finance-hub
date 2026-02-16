# typed: false
# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    before_action :require_admin!

    private

    def require_admin!
      profile = Profile.find_by(user_id: current_user&.id&.to_s)
      unless profile&.is_admin?
        redirect_to(root_path, alert: "Not authorized.")
      end
    end
  end
end

# typed: false
# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    def index
      @profiles = Profile.includes(:family).all
    end
  end
end

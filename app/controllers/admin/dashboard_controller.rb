# typed: false
# frozen_string_literal: true

module Admin
  class DashboardController < BaseController
    def index
      @families_count = Family.count
      @profiles_count = Profile.count
      @accounts_count = Account.count
      @total_net_worth = Account.active.includes(:category, :value_snapshots).sum do |a|
        a.debt? ? -a.latest_value_usd.to_f : a.latest_value_usd.to_f
      end
    end
  end
end

# typed: false
# frozen_string_literal: true

module Admin
  class FamiliesController < BaseController
    def index
      @families = Family.all
    end

    def show
      @family = Family.find(params[:id])
      @members = @family.members
      @accounts = @family.accounts.includes(:category, :member, :value_snapshots)
    end
  end
end

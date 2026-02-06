# typed: false
# frozen_string_literal: true

class SettingsController < ApplicationController
  def index
    @owners = Owner.all
    @categories = Category.ordered
  end
end

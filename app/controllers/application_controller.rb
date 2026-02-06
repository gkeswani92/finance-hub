# typed: false
# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Minerva::Authentication
  include ShopifySecurityBase::ClickjackingProtection
  skip_idor_protection
end

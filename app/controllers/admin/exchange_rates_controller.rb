# typed: false
# frozen_string_literal: true

module Admin
  class ExchangeRatesController < BaseController
    def index
      @rates = ExchangeRate.order(rate_date: :desc).limit(30)
    end

    def create
      rate = ExchangeRate.new(rate_params)
      if rate.save
        redirect_to(admin_exchange_rates_path, notice: "Rate added.")
      else
        redirect_to(admin_exchange_rates_path, alert: rate.errors.full_messages.join(", "))
      end
    end

    private

    def rate_params
      params.require(:exchange_rate).permit(:base_currency, :target_currency, :rate, :rate_date, :source)
    end
  end
end

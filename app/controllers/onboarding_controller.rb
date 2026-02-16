# typed: false
# frozen_string_literal: true

class OnboardingController < ApplicationController
  def index
  end

  def create_family
    family = Family.new(
      name: params[:family_name],
      created_by: current_user_id,
      invite_code: SecureRandom.hex(6),
      base_currency: params[:base_currency] || "USD",
    )

    if family.save
      profile = Profile.find_or_initialize_by(user_id: current_user_id)
      profile.update!(family: family, family_role: "admin")

      # Seed default asset types
      seed_default_categories(family)

      redirect_to(root_path, notice: "Family created!")
    else
      redirect_to(onboarding_path, alert: family.errors.full_messages.join(", "))
    end
  end

  def join_family
    family = Family.find_by(invite_code: params[:invite_code])

    unless family
      redirect_to(onboarding_path, alert: "Invalid invite code.")
      return
    end

    profile = Profile.find_or_initialize_by(user_id: current_user_id)
    profile.update!(family: family, family_role: "member")

    redirect_to(root_path, notice: "Joined #{family.name}!")
  end

  private

  def current_user_id
    current_user&.id&.to_s || "anonymous"
  end

  def seed_default_categories(family)
    defaults = [
      { name: "Cash", is_debt: false, is_liquid: true, icon: "banknote" },
      { name: "Brokerage", is_debt: false, is_liquid: true, icon: "trending-up" },
      { name: "Retirement", is_debt: false, is_liquid: false, icon: "landmark" },
      { name: "Real Estate", is_debt: false, is_liquid: false, icon: "home" },
      { name: "Crypto", is_debt: false, is_liquid: true, icon: "bitcoin" },
      { name: "Credit Card", is_debt: true, is_liquid: true, icon: "credit-card" },
      { name: "Loan", is_debt: true, is_liquid: true, icon: "receipt" },
    ]

    defaults.each_with_index do |attrs, i|
      family.categories.create!(attrs.merge(display_order: i + 1))
    end
  end
end

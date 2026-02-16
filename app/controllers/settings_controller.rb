# typed: false
# frozen_string_literal: true

class SettingsController < ApplicationController
  def index
    @members = Member.ordered
    @categories = Category.ordered
    @new_member = Member.new
    @new_category = Category.new
  end

  def create_member
    member = Member.new(member_params)
    if member.save
      redirect_to(settings_path, notice: "Member '#{member.name}' created.")
    else
      redirect_to(settings_path, alert: member.errors.full_messages.join(", "))
    end
  end

  def update_member
    member = Member.find(params[:id])
    if member.update(member_params)
      redirect_to(settings_path, notice: "Member '#{member.name}' updated.")
    else
      redirect_to(settings_path, alert: member.errors.full_messages.join(", "))
    end
  end

  def destroy_member
    member = Member.find(params[:id])
    if member.destroy
      redirect_to(settings_path, notice: "Member '#{member.name}' deleted.")
    else
      redirect_to(settings_path, alert: member.errors.full_messages.join(", "))
    end
  end

  def reorder_members
    ids = params[:ids] || []
    ids.each_with_index do |id, index|
      Member.where(id: id).update_all(display_order: index + 1)
    end
    head(:ok)
  end

  def create_category
    category = Category.new(category_params)
    if category.save
      redirect_to(settings_path, notice: "Category '#{category.name}' created.")
    else
      redirect_to(settings_path, alert: category.errors.full_messages.join(", "))
    end
  end

  def update_category
    category = Category.find(params[:id])
    if category.update(category_params)
      redirect_to(settings_path, notice: "Category '#{category.name}' updated.")
    else
      redirect_to(settings_path, alert: category.errors.full_messages.join(", "))
    end
  end

  def destroy_category
    category = Category.find(params[:id])
    if category.destroy
      redirect_to(settings_path, notice: "Category '#{category.name}' deleted.")
    else
      redirect_to(settings_path, alert: category.errors.full_messages.join(", "))
    end
  end

  def reorder_categories
    ids = params[:ids] || []
    ids.each_with_index do |id, index|
      Category.where(id: id).update_all(display_order: index + 1)
    end
    head(:ok)
  end

  def update_display_currency
    session[:display_currency] = params[:currency] == "INR" ? "INR" : "USD"
    redirect_back(fallback_location: root_path)
  end

  private

  def member_params
    params.require(:member).permit(:name, :member_type, :color, :is_active)
  end

  def category_params
    params.require(:category).permit(:name, :display_order, :is_debt, :is_liquid, :icon)
  end
end

# typed: false
# frozen_string_literal: true

class SettingsController < ApplicationController
  def index
    @owners = Owner.all
    @categories = Category.ordered
    @new_owner = Owner.new
    @new_category = Category.new
  end

  def create_owner
    owner = Owner.new(owner_params)
    if owner.save
      redirect_to(settings_path, notice: "Owner '#{owner.name}' created.")
    else
      redirect_to(settings_path, alert: owner.errors.full_messages.join(", "))
    end
  end

  def destroy_owner
    owner = Owner.find(params[:id])
    if owner.destroy
      redirect_to(settings_path, notice: "Owner '#{owner.name}' deleted.")
    else
      redirect_to(settings_path, alert: owner.errors.full_messages.join(", "))
    end
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

  private

  def owner_params
    params.require(:owner).permit(:name)
  end

  def category_params
    params.require(:category).permit(:name, :display_order, :is_debt)
  end
end

# typed: false
# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  def index
    @accounts = Account.active.includes(:category, :owner, :value_snapshots)
    @accounts = @accounts.where(owner_id: params[:owner_id]) if params[:owner_id].present?
    @accounts = @accounts.joins(:category).order("categories.display_order, accounts.name")

    @owners = Owner.all
    @categories = Category.ordered
  end

  def show
    @snapshots = @account.value_snapshots.order(snapshot_date: :desc)
  end

  def new
    @account = Account.new
    load_form_data
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to(accounts_path, notice: "Account created.")
    else
      load_form_data
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit
    load_form_data
  end

  def update
    if @account.update(account_params)
      redirect_to(accounts_path, notice: "Account updated.")
    else
      load_form_data
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @account.update!(is_active: false)
    redirect_to(accounts_path, notice: "Account archived.")
  end

  def bulk_update
    @accounts = Account.active.includes(:category, :owner, :value_snapshots)
      .joins(:category).order("categories.display_order, accounts.name")
  end

  def save_bulk_update
    today = Date.current
    saved = 0

    (params[:snapshots] || {}).each do |account_id, value_str|
      next if value_str.blank?

      account = Account.find(account_id)
      snapshot = account.value_snapshots.find_or_initialize_by(snapshot_date: today)
      snapshot.value = value_str.to_d
      saved += 1 if snapshot.save
    end

    redirect_to(bulk_update_accounts_path, notice: "Updated #{saved} account(s).")
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(
      :name,
      :owner_id,
      :category_id,
      :institution,
      :currency,
      :cost_basis,
      :is_active,
      :notes,
    )
  end

  def load_form_data
    @owners = Owner.all
    @categories = Category.ordered
  end
end

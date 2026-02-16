# typed: false
# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :unarchive]

  def index
    @accounts = Account.active.includes(:category, :member, :value_snapshots)
    @accounts = @accounts.where(member_id: params[:member_id]) if params[:member_id].present?
    @accounts = @accounts.joins(:category).order("categories.display_order, accounts.name")

    @members = Member.all
    @categories = Category.all.sort_by { |c| -@accounts.select { |a| a.category_id == c.id }.sum(&:latest_value_usd) }
    @archived_accounts = Account.where(is_active: false).includes(:category, :member, :value_snapshots)
    @archived_accounts = @archived_accounts.where(member_id: params[:member_id]) if params[:member_id].present?
  end

  def show
    @snapshots = @account.value_snapshots.order(snapshot_date: :desc)
    load_form_data
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
    redirect_to(account_path(@account))
  end

  def update
    if @account.update(account_params)
      redirect_to(account_path(@account), notice: "Account updated.")
    else
      @snapshots = @account.value_snapshots.order(snapshot_date: :desc)
      load_form_data
      render(:show, status: :unprocessable_entity)
    end
  end

  def destroy
    @account.update!(is_active: false)
    @account.value_snapshots.find_or_create_by!(snapshot_date: Date.current) do |s|
      s.value = 0
    end.tap { |s| s.update!(value: 0) }
    redirect_to(accounts_path, notice: "Account archived.")
  end

  def unarchive
    @account.update!(is_active: true)
    @account.value_snapshots.where(snapshot_date: Date.current, value: 0).destroy_all
    redirect_to(accounts_path, notice: "Account unarchived.")
  end

  def bulk_update
    @accounts = Account.active.includes(:category, :member, :value_snapshots)
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
      :member_id,
      :category_id,
      :institution,
      :currency,
      :cost_basis,
      :is_active,
      :notes,
    )
  end

  def load_form_data
    @members = Member.all
    @categories = Category.ordered
  end
end

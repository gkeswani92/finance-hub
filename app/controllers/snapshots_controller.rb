# typed: false
# frozen_string_literal: true

class SnapshotsController < ApplicationController
  def create
    @account = Account.find(params[:account_id])
    @snapshot = @account.value_snapshots.find_or_initialize_by(
      snapshot_date: snapshot_params[:snapshot_date],
    )
    @snapshot.value = snapshot_params[:value]

    if @snapshot.save
      redirect_to(account_path(@account), notice: "Value recorded.")
    else
      redirect_to(account_path(@account), alert: @snapshot.errors.full_messages.join(", "))
    end
  end

  def destroy
    @account = Account.find(params[:account_id])
    @snapshot = @account.value_snapshots.find(params[:id])
    @snapshot.destroy
    redirect_to(account_path(@account), notice: "Snapshot deleted.")
  end

  private

  def snapshot_params
    params.require(:value_snapshot).permit(:snapshot_date, :value)
  end
end

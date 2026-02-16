# typed: false
# frozen_string_literal: true

class ImportsController < ApplicationController
  def index
    @members = Member.all
    @categories = Category.ordered
  end

  def parse
    file = params[:file]
    unless file
      redirect_to(import_path, alert: "Please select a CSV file.")
      return
    end

    content = file.read
    @parsed = KuberaCsvParser.parse(content)
    @members = Member.all
    @categories = Category.ordered

    render(:index)
  end

  def execute
    mappings = params[:mappings] || {}
    accounts_data = JSON.parse(params[:accounts_data] || "[]")

    created = 0
    ActiveRecord::Base.transaction do
      accounts_data.each do |data|
        member = Member.find_by(id: mappings.dig("members", data["sheet"]))
        category = Category.find_by(id: mappings.dig("categories", data["section"]))
        next unless member && category

        account = Account.find_or_create_by!(
          name: data["name"],
          member: member,
        ) do |a|
          a.category = category
          a.institution = data["provider"]
          a.currency = data["currency"] || "USD"
        end

        value = data["value"].to_d
        account.value_snapshots.find_or_create_by!(snapshot_date: Date.current) do |s|
          s.value = value
        end.tap { |s| s.update!(value: value) }

        created += 1
      end
    end

    redirect_to(accounts_path, notice: "Imported #{created} account(s).")
  end
end

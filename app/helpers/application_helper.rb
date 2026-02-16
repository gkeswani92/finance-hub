# typed: false
# frozen_string_literal: true

module ApplicationHelper
  def sidebar_link(label, path, icon_svg)
    active = current_page?(path)
    base = "flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition-colors"
    classes = if active
      "#{base} bg-gray-100 text-gray-900"
    else
      "#{base} text-gray-500 hover:bg-gray-50 hover:text-gray-900"
    end

    link_to(path, class: classes, data: { turbo_frame: "_top" }) do
      icon_svg.html_safe + tag.span(label)
    end
  end

  def format_currency(amount, currency = "USD")
    prefix = currency == "INR" ? "\u20B9" : "$"
    "#{prefix}#{number_with_delimiter(amount.to_i)}"
  end

  def format_currency_compact(amount)
    abs = amount.to_f.abs
    sign = amount < 0 ? "-" : ""
    if abs >= 1_000_000
      "#{sign}$#{format("%.2f", abs / 1_000_000)}M"
    elsif abs >= 1_000
      "#{sign}$#{format("%.0f", abs / 1_000)}K"
    else
      "#{sign}$#{format("%.0f", abs)}"
    end
  end

  def format_currency_human(amount)
    abs = amount.to_i.abs
    if abs >= 1_000_000
      millions = abs / 1_000_000.0
      formatted = format("%.3f", millions)
      sign = amount < 0 ? "-" : ""
      tag.span(class: "inline-flex items-baseline gap-1") do
        tag.span("#{sign}$", class: "text-lg font-medium text-gray-400") +
          tag.span(formatted, class: "text-5xl font-bold tracking-tight") +
          tag.span("Million", class: "text-lg font-medium text-gray-400 ml-1")
      end
    else
      tag.span(class: "inline-flex items-baseline gap-1") do
        tag.span("$", class: "text-lg font-medium text-gray-400") +
          tag.span(number_with_delimiter(abs), class: "text-5xl font-bold tracking-tight")
      end
    end
  end

  def format_currency_dual(account)
    usd = format_currency(account.latest_value_usd, "USD")
    return usd if account.currency == "USD"

    native = format_currency(account.latest_value, account.currency)
    tag.div(usd) + tag.div(native, class: "text-gray-400 text-xs")
  end

  def change_color_class(value)
    if value > 0
      "text-emerald-600"
    elsif value < 0
      "text-red-500"
    else
      "text-gray-400"
    end
  end

  def member_badge(member)
    return "" unless member

    tag.span(
      class: "inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-xs font-medium",
      style: "background-color: #{member.color}20; color: #{member.color}",
    ) do
      tag.span("", class: "w-1.5 h-1.5 rounded-full", style: "background-color: #{member.color}") +
        tag.span(member.name)
    end
  end

  # SVG icon helpers for sidebar
  def icon_dashboard
    '<svg class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" /></svg>'
  end

  def icon_accounts
    '<svg class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" /></svg>'
  end

  def icon_performance
    '<svg class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" /></svg>'
  end

  def icon_import
    '<svg class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" /></svg>'
  end

  def icon_settings
    '<svg class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.066 2.573c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.573 1.066c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.066-2.573c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" /><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /></svg>'
  end
end

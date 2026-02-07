# typed: false
# frozen_string_literal: true

module ApplicationHelper
  def sidebar_link(label, path, icon_path)
    active = current_page?(path)
    base = "flex items-center px-3 py-2 text-sm font-medium transition-colors border-l-2"
    classes = if active
      "#{base} border-teal-600 bg-teal-50 text-teal-700"
    else
      "#{base} border-transparent text-gray-500 hover:bg-gray-50 hover:text-gray-900"
    end

    link_to(path, class: classes, data: { turbo_frame: "_top" }) do
      tag.svg(
        xmlns: "http://www.w3.org/2000/svg",
        class: "h-5 w-5 mr-3 flex-shrink-0",
        fill: "none",
        viewBox: "0 0 24 24",
        stroke: "currentColor",
        stroke_width: "1.5",
      ) { tag.path(d: icon_path, stroke_linecap: "round", stroke_linejoin: "round") } +
        tag.span(label)
    end
  end

  def format_currency(amount, currency = "USD")
    prefix = currency == "INR" ? "\u20B9" : "$"
    "#{prefix}#{number_with_delimiter(amount.to_i)}"
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
end

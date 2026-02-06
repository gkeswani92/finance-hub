# typed: false
# frozen_string_literal: true

module ApplicationHelper
  def sidebar_link(label, path, icon_path)
    active = current_page?(path)
    base = "flex items-center px-3 py-2 rounded-lg text-sm font-medium transition-colors"
    classes = active ? "#{base} bg-gray-800 text-white" : "#{base} text-gray-300 hover:bg-gray-800 hover:text-white"

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
end

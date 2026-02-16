# typed: false
# frozen_string_literal: true

class KuberaCsvParser
  # Parses Kubera CSV export format
  # Returns array of hashes: { name, value_usd, value_local, currency, provider, section, sheet }
  def self.parse(content)
    lines = content.lines.map(&:chomp)

    # Skip first 4 header rows
    lines = lines.drop(4)
    return [] if lines.empty?

    # Parse column headers
    headers = parse_csv_line(lines.shift)
    return [] unless headers

    col = {}
    headers.each_with_index do |h, i|
      normalized = h&.strip&.downcase
      case normalized
      when "name" then col[:name] = i
      when "value (usd)" then col[:value_usd] = i
      when "value (asset currency)" then col[:value_local] = i
      when "asset currency" then col[:currency] = i
      when "provider name" then col[:provider] = i
      when "section name" then col[:section] = i
      when "sheet name" then col[:sheet] = i
      when "cost" then col[:cost] = i
      end
    end

    results = []
    lines.each do |line|
      fields = parse_csv_line(line)
      next unless fields && fields[col[:name]].present?

      name = fields[col[:name]]&.strip
      next if name.blank?

      results << {
        name: name,
        value_usd: fields[col[:value_usd]]&.to_f || 0,
        value_local: fields[col[:value_local]]&.to_f || 0,
        currency: fields[col[:currency]]&.strip || "USD",
        provider: fields[col[:provider]]&.strip,
        section: fields[col[:section]]&.strip,
        sheet: fields[col[:sheet]]&.strip,
        cost: fields[col[:cost]]&.to_f,
      }
    end

    results
  end

  def self.parse_csv_line(line)
    return if line.nil?

    require "csv"
    CSV.parse_line(line)
  rescue CSV::MalformedCSVError
    line.split(",").map(&:strip)
  end
end

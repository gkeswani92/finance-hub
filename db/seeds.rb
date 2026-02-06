# frozen_string_literal: true

# Owners
["Gaurav", "Priyanka", "Joint"].each do |name|
  Owner.find_or_create_by!(name: name)
end

# Categories (asset categories first, then debt)
asset_categories = [
  { name: "Cash", display_order: 1 },
  { name: "Taxable", display_order: 2 },
  { name: "Retirement", display_order: 3 },
  { name: "PMS & AIF", display_order: 4 },
  { name: "Real Estate", display_order: 5 },
  { name: "Crypto", display_order: 6 },
  { name: "Other Assets", display_order: 7 },
]

debt_categories = [
  { name: "Mortgage", display_order: 10, is_debt: true },
  { name: "Loans", display_order: 11, is_debt: true },
  { name: "Credit Cards", display_order: 12, is_debt: true },
]

(asset_categories + debt_categories).each do |attrs|
  Category.find_or_create_by!(name: attrs[:name]) do |c|
    c.display_order = attrs[:display_order]
    c.is_debt = attrs.fetch(:is_debt, false)
  end
end

puts "Seeded #{Owner.count} owners, #{Category.count} categories"

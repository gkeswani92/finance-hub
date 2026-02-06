# typed: false
# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# D3 via CDN
pin "d3", to: "https://cdn.jsdelivr.net/npm/d3@7/+esm"
pin "d3-sankey", to: "https://cdn.jsdelivr.net/npm/d3-sankey@0.12/+esm"

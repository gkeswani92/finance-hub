# Finance Hub

A self-hosted personal net worth tracker. Track assets and debts across multiple accounts, owners, and categories with historical value tracking, multi-currency support (USD/INR), and rich visualizations.

This is **not** a budgeting tool. No transaction-level tracking. The core workflow is: periodically update account values and see how net worth evolves over time.

## Features

- **Dashboard** with net worth summary cards (total assets, debts, net worth) and period-over-period changes
- **Accounts** organized by owner (Gaurav, Priyanka, Joint) and category (Taxable, Retirement, PMS & AIF, etc.)
- **Bulk update** page for rapid value entry across all accounts
- **Sankey diagram** showing money flow: Categories → Owners → Assets/Debts → Net Worth
- **Net worth time-series chart** tracking portfolio value over time
- **Per-account value history** charts and snapshot tables
- **Multi-currency** support with automatic USD/INR conversion via Frankfurter API

## Tech Stack

| Component | Choice |
|---|---|
| Framework | Rails 8 |
| Database | MySQL (via Trilogy) |
| JS | Importmaps + D3 via jsdelivr CDN |
| CSS | Tailwind CSS (CDN) |
| Charts | D3.js + d3-sankey |
| JS Framework | Hotwire (Turbo + Stimulus) |
| FX Rates | Frankfurter API |

## Getting Started

```bash
dev clone finance-hub
dev up
bin/rails db:migrate
bin/rails db:seed
dev server
```

## Commands

| Command | Description |
|---|---|
| `dev server` | Start the Rails development server |
| `dev test` | Run the test suite |
| `dev style` | Run Rubocop linting |
| `bin/rails db:seed` | Seed owners and categories |
| `bin/rails kubera:import` | Import accounts from a JSON export (see below) |

## Data Import

To bulk-import accounts from a JSON export:

```bash
bin/rails kubera:import                          # reads ~/Downloads/Gaurav Keswani.json
bin/rails kubera:import FILE=/path/to/export.json  # custom path
```

This creates accounts, sets cost basis, records today's value snapshot, and fetches the current USD/INR exchange rate.

## Database Schema

- **owners** — People who own accounts (Gaurav, Priyanka, Joint)
- **categories** — Account groupings with asset/debt flag (Taxable, Retirement, Credit Cards, etc.)
- **accounts** — Individual financial accounts with owner, category, currency, cost basis
- **value_snapshots** — Historical values per account per date (the core time-series)
- **cash_flows** — Money in/out events for IRR calculations (deposit, withdrawal, dividend)
- **exchange_rates** — Cached daily FX rates (USD/INR)

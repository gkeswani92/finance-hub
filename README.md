<!--
Thanks for using the README Template!
* Consider the value each optional section brings before removing it
* Reference the commented out examples for each section
* Leave feedback about the template in the [Google Doc](https://docs.google.com/document/d/1tP6Dh4qFS5dh9GKvpqpZeOYa_hZ8OE9G2EkgPUsDE6I/edit?usp=sharing) or in [#dev-context](https://shopify.slack.com/archives/CEQ6MR2F7)
* Check out the [development-docs README](https://github.com/Shopify/development-docs/blob/master/README.md) to see the template in action
-->

# Finance Hub

**Badges:** Services found in ServicesDB have the option to show build badges, offering quick links and build status information. When selecting badges, consider the most important statuses for your repo.
[![finance-hub/production](https://services.shopify.io/services/finance-hub/production/badge.svg)](https://services.shopify.io/services/finance-hub/overview)

* **Buildkite status badge:** Available if your repo is for a service. [Follow the help guide to get your badge code](https://buildkite.com/docs/integrations/build-status-badges).
* **Other badges (optional):** Additional status badges relevant to your project can be found at http://shields.io/.
* **Custom badges:** Custom badges can be added using small image icons of your choice. Popular custom badges include Shipit and Splunk.

<!--
Examples:
* Plus B2B Learning Project: Handshake Importer Prototype - custom badges](https://github.com/Shopify/plus-b2b-learning-project-hs-importer/blob/master/README.md)
-->

[About this repo](#about-this-repo) | [Projects & Roadmap](#projects--roadmap-optional) |  [Commands](#commands) | [How to use this repo](#how-to-use-this-repo) | [Contribute to this repo](#contribute-to-this-repo-optional) | [Technical details](#technical-details)

## About this repo

**Introduction:** Main goal of the repo, and why it's important. 2-3 short paragraphs.

|                |                                                                                                                                      |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------|
| Current status | Current project status. Maintenance, deprecated, beta, etc. Include link to roadmap                                                  |
| Owner          | Who maintains the project? Link to vault team(s) and slack channels. Break into new section if extensive.
| Help           | Where to go for help or ask questions. Link any relevant help channels, playbooks or resources. Break into new section if extensive. |

**Guiding principles (optional)**: What everlasting principles drive the design of this project? If related to a specific project, this could be your success criteria, or design goals.

<!--
Examples:
* [Delivery component - goal statement content](https://github.com/Shopify/shopify/blob/master/components/delivery/README.md)
* [Domains component - goal statement content](https://github.com/Shopify/shopify/tree/master/components/domains/README.md)
* [Covid Shield - guiding principles and rationale](https://github.com/CovidShield/rationale/blob/master/README.md#principles)
* [App component - Large owner and support channel table](https://github.com/Shopify/shopify/blob/master/components/apps/README.md#apps-platform)
* [Business Platform - Stewards table with github teams](https://github.com/Shopify/business-platform/blob/master/README.md#stewards)
* [Partners - Goals section and quick start guide](https://github.com/Shopify/partners/blob/master/docs/README.md#goals)
* [Seamster - Motivation & intent section](https://github.com/Shopify/seamster/blob/master/README.md#motivation--intent)
-->

## Projects & roadmap (optional)

Link to projects and roadmaps where relevant. A high level overview of the future of the repo. This section should guide the reader towards understanding what features currently exist and what features are planned.

| Feature name | Feature description                                                         |
|--------------|-----------------------------------------------------------------------------|
| Feature      | Example description of the feature (link to relevant project if applicable). Marked as Done, ongoing or planned. |

<!--
Examples:
* [Magellan - Properties and wishlist content](https://github.com/Shopify/magellan/blob/master/README.md#architecture)
-->

## Commands

[See all commands in the dev.yml file](dev.yml)


<!--
Examples:
* [Tally - Feature documentation content](https://github.com/Shopify/tally/blob/master/README.md)
-->

## How to use this repo

This repo requires the following:
- MySQL
- Ruby

### Quick start guide

- Clone the repo with `dev clone finance-hub`
- Run `dev up` to install dependencies
- Start the development server via `dev server`
- Open the server with `Ctrl+T`

### Helpful commands

- Run tests with `dev test`

Read the [GETTING STARTED](GETTING_STARTED.md) document for help developing with the Shopify Rails Stack.

<!--
Examples:
* [Storefront Renderer- Quick start guide](https://github.com/Shopify/storefront-renderer#development-quick-start)
* [CloudSQLBuddy - How it works content and formatting](https://github.com/Shopify/cloudbuddies/tree/master/buddies/cloudsqlbuddy/README.md)
* [gjtorikian/html-proofer - Configuration and real life examples](https://github.com/gjtorikian/html-proofer/blob/main/README.md#configuration)
* [Polaris Icons - Separate contribution guide](https://github.com/Shopify/polaris-icons/blob/master/README.md#contributing-)
* [Magellan - Collecting in production content](https://github.com/Shopify/magellan/blob/master/README.md#connecting-to-magellan-in-production)
-->

## Contribute to this repo (optional)

Any additional details for contributors. This differs from the getting started section in that its purpose is development and not just use. Can include additional steps such as:
* What is necessary for PRs (formatting, pings)
* Architecture and style guides

Before removing this section, consider whether a new hire reading this README for the first time would be able to understand how to contribute to the repo. If the content exceeds 3 paragraphs or includes large tables/graphs, break out into a CONTRIBUTING.md file, and link to it.

<!--
Examples:
* [Delivery component - Architecture and style onboarding content](https://github.com/Shopify/shopify/blob/master/components/delivery/README.md#component-architecture-and-style)
* [Oberlo Merchant - Developer onboarding format](https://github.com/Shopify/oberlo-merchant/blob/master/README.md#getting-started)
* [Business Platform - Development and deployment content](https://github.com/Shopify/business-platform/blob/master/README.md#development)
* [Good CONTRIBUTING.md template gist](https://gist.github.com/PurpleBooth/b24679402957c63ec426)
-->

## Technical details

This section can be used to outline specific technical info for the repo. Before adding content to this section, consider whether the README is the right place for your content. [The Vault page on context sharing](https://vault.shopify.io/pages/207-Context-Sharing) can help you determine the right place for your content, and link back to the README.

- [Shopify Build](https://buildkite.com/shopify/finance-hub)
- [Shipit](https://shipit.shopify.io/shopify/finance-hub/production)
- [Cloud Portal](https://cloud-portal-apps-b-us-central1-3.shopifycloud.com/namespaces/finance-hub-production-unrestricted/workloads)
- [Splunk](https://logs.shopify.io/en-US/app/search/search?q=search%20application%3D%22finance-hub-production-unrestricted%22)
- [Bugsnag](https://app.bugsnag.com/shopify/finance-hub/errors)

<!--
Examples:
* [Billing gem - Link to github wiki for long form instructions](https://github.com/shopify/billing#running-shopify-and-billing-locally-with-real-api-calls)
* [Shopify payments component - Link to specific files in key entities](https://github.com/Shopify/shopify/tree/master/components/shopify_payments/README.md#key-entities)
* [Shop mover component - Link to the shop mover playbook](https://github.com/Shopify/shopify/tree/master/components/shop_mover/README.md)
* [Polaris Icons - Repo specific section: Licenses](https://github.com/Shopify/polaris-icons/blob/master/README.md#licenses-)
-->

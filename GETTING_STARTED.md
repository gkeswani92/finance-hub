# Getting started

##### _Follow these directions for specific instructions to set your app up:_
1. Create a new service and GitHub repository [on Services DB](https://services.shopify.io/services/new).
  - _Note: Ensure you create a **Blank** service. Creating a Rails app from within Services DB is deprecated._
2. Push the code created by `dev init` to your new GitHub repository.
3. Follow the [Shopify Build instructions](https://shopify-build.docs.shopify.io/getting_started/quick_start) to set up a CI pipeline.
4. Deploy your application with prod-kit. Follow the [_Getting Started with Rails_ walkthrough](https://github.com/Shopify/prod-kit/blob/main/docs/recipes/rails-getting-started.md).

Shopify-flavoured Rails apps are different from vanilla Rails apps in a few exciting ways:

- Default Shopify tools configured out of the box. ✨
- Database set up with Trilogy, a modern, open-source MySQL client. 🛢
- Dev and Spin set up to make local and cloud development a breeze. 💨

## What you get out of the box 💎

The generated app comes with several things configured and ready to run, such as the latest version of Ruby, and Ruby on Rails backend. You now have to do very minimal setup to start developing your code.

Your app also comes with other features set up by default:

- _dev_: dev is set up just like you use it everywhere, with `dev test`, `dev server`, and `dev console`.
- _Type checking and linters_: Type checkers and linters follow the Shopify style guides. To simplify your life, `dev style` and `dev typecheck` are included. Not only that, but the code you get upon creation is already linted and type-checked, starting your app from a clean slate.
- _Dependabot_: Your dependencies are automatically checked and Dependabot will remind you to upgrade them when an update is available.
- _CI_: Your app is configured for CI via Shopify Build (setup is completed via instructions above).

All you need to do is write code and ship it!

## Useful commands 🗣

Show the machine who’s in charge!

- `dev console` to access your Rails console in development
- `dev server` to run your app in development
- `dev style` for code linting with Rubocop, TypeScript, eslint, Prettier, and stylelint
- `dev test` to run your ruby test suites
- `dev test-frontend` to run your node test suites
- `dev typecheck` for static type checking with Sorbet and eslint
  - _Note: Sorbet will need to be configured first. Use `bundle exec srb init` to get started._

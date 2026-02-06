# typed: false
# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    # For directives that are not defined here, they will fallback to default-src
    policy.default_src(:self)

    if Rails.env.development?
      policy.img_src(:self, :data)
    else
      policy.img_src(:self, :data, "cdn.shopify.com")
      policy.script_src("cdn.shopify.com")
      policy.style_src("cdn.shopify.com")
    end

    # Disable <embed>, <object> and <applet> tags
    policy.object_src(:none)

    # Disable <base> tags
    policy.base_uri(:none)

    # Prevent the application from being iframed
    policy.frame_ancestors(:none)

    # Automatically upgrade HTTP resources to HTTPS
    policy.upgrade_insecure_requests(true)

    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Generate session nonces for permitted importmap and inline scripts
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = ["script-src"]

  # Report CSP violations to a specified URI. See:
  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
  # config.content_security_policy_report_only = true
end

# frozen_string_literal: true

module Docuseal
  PRODUCT_URL = 'https://sign.averox.com'
  NEWSLETTER_URL = "#{PRODUCT_URL}/newsletters".freeze
  ENQUIRIES_URL = "#{PRODUCT_URL}/enquiries".freeze
  PRODUCT_NAME = 'Averox Document Signing'
  DEFAULT_APP_URL = 'http://localhost:3000'
  GITHUB_URL = 'https://github.com/averox-solutions'
  DISCORD_URL = 'https://averox.com'
  TWITTER_URL = 'https://twitter.com/Averoxinc/'
  TWITTER_HANDLE = '@Averoxinc'
  SUPPORT_EMAIL = 'support@averox.com'
  HOST = ENV.fetch('HOST', 'localhost')
  CONSOLE_URL = if Rails.env.development?
                  'http://console.localhost.io:3001'
                elsif ENV['MULTITENANT'] == 'true'
                  "https://console.#{HOST}"
                else
                  'https://sign.averox.com'
                end
  CDN_URL = if Rails.env.development?
              'http://localhost:3000'
            elsif ENV['MULTITENANT'] == 'true'
              "https://cdn.#{HOST}"
            else
              'https://cdn.docuseal.co'
            end

  CERTS = JSON.parse(ENV.fetch('CERTS', '{}'))
  TIMESERVER_URL = ENV.fetch('TIMESERVER_URL', nil)

  DEFAULT_URL_OPTIONS = {
    host: HOST,
    protocol: ENV['FORCE_SSL'].present? ? 'https' : 'http'
  }.freeze

  module_function

  def multitenant?
    ENV['MULTITENANT'] == 'true'
  end

  def demo?
    ENV['DEMO'] == 'true'
  end

  def active_storage_public?
    ENV['ACTIVE_STORAGE_PUBLIC'] == 'true'
  end

  def default_url_options
    return DEFAULT_URL_OPTIONS if multitenant?

    @default_url_options ||= begin
      value = EncryptedConfig.find_by(key: EncryptedConfig::APP_URL_KEY)&.value
      value ||= DEFAULT_APP_URL
      url = Addressable::URI.parse(value)
      { host: url.host, port: url.port, protocol: url.scheme }
    end
  end

  def product_name
    PRODUCT_NAME
  end

  def refresh_default_url_options!
    @default_url_options = nil
  end
end

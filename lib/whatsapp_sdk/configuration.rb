# frozen_string_literal: true

module WhatsappSdk
  # This module allows client instantiating the client as a singleton like the following example:
  # WhatsappSdk.configure do |config|
  #   config.access_token = ACCESS_TOKEN
  #   config.api_version = API_VERSION
  # end
  #
  # The gem have access to the client through WhatsappSdk.configuration.client
  class Configuration
    attr_accessor :access_token, :api_version

    # loggers like ActiveSupport::Logger (Rails.logger) is a subclass of Logger
    attr_accessor :logger, :logger_options

    def initialize(
      access_token = "",
      api_version = Api::ApiConfiguration::DEFAULT_API_VERSION,
      logger = nil,
      logger_options = {}
    )
      @access_token = access_token
      @api_version = api_version
      @logger = logger
      @logger_options = logger_options
    end

    def client
      Api::Client.new(access_token, api_version, logger, logger_options)
    end
  end
end

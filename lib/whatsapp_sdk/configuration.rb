# typed: strict
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
    extend T::Sig

    sig { returns(String) }
    attr_accessor :access_token

    sig { returns(String) }
    attr_accessor :api_version

    # loggers like ActiveSupport::Logger (Rails.logger) is a subclass of Logger
    sig { returns(T.nilable(T.any(Logger, T.class_of(Logger)))) }
    attr_accessor :logger

    sig { returns(T::Hash[T.untyped, T.untyped]) }
    attr_accessor :logger_options

    sig do
      params(
        access_token: String,
        api_version: String,
        logger: T.nilable(T.any(Logger, T.class_of(Logger))),
        logger_options: T::Hash[T.untyped, T.untyped]
      ).void
    end
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

    sig { returns(Api::Client) }
    def client
      Api::Client.new(access_token, api_version, logger, logger_options)
    end
  end
end

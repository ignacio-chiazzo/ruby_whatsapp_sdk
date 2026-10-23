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
    SETTINGS = %i[access_token api_version logger logger_options adapter request_options
                  multipart_request_options middleware].freeze
    # Stored frozen, so editing them in place raises instead of being ignored by the cached client.
    HASH_SETTINGS = %i[logger_options request_options multipart_request_options].freeze
    REQUEST_OPTION_SETTINGS = %i[request_options multipart_request_options].freeze

    # loggers like ActiveSupport::Logger (Rails.logger) is a subclass of Logger
    attr_reader(*SETTINGS)

    # Changing a setting makes #client build a new client on its next call. The old client is not closed, because
    # other threads may still be using it.
    SETTINGS.each do |name|
      define_method(:"#{name}=") do |value|
        value = value.dup.freeze if HASH_SETTINGS.include?(name)
        Api::Client.validate_request_options(value) if REQUEST_OPTION_SETTINGS.include?(name)
        @mutex.synchronize do
          @client = nil
          instance_variable_set(:"@#{name}", value)
        end
      end
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
      @logger_options = logger_options.dup.freeze
      @adapter = nil
      @request_options = {}.freeze
      @multipart_request_options = {}.freeze
      @middleware = nil
      @mutex = Mutex.new
    end

    # One client is shared by every API object built from this configuration, so its connections are reused.
    # @return [Api::Client]
    def client
      @mutex.synchronize do
        @client ||= Api::Client.new(
          access_token, api_version, logger, logger_options,
          adapter: adapter, request_options: request_options, multipart_request_options: multipart_request_options,
          middleware: middleware
        )
      end
    end
  end
end

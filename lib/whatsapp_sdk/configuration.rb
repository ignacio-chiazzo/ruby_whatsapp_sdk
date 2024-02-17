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

    sig { params(access_token: String, api_version: String).void }
    def initialize(access_token = "", api_version = Api::ApiConfiguration::DEFAULT_API_VERSION)
      @access_token = access_token
      @api_version = api_version
    end

    sig { returns(Api::Client) }
    def client
      Api::Client.new(access_token, api_version)
    end
  end
end

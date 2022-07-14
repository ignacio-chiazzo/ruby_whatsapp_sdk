# frozen_string_literal: true

module WhatsappSdk
  # This module allows client instantiating the client as a singleton like the following example:
  # WhatsappSdk.configure do |config|
  #   config.access_token = ACCESS_TOKEN
  # end
  #
  # The gem have access to the client through WhatsappSdk.configuration.client
  class Configuration
    attr_accessor :access_token

    def initialize(access_token = nil)
      @access_token = access_token
    end

    def client
      return unless access_token

      WhatsappSdk::Api::Client.new(access_token)
    end
  end
end

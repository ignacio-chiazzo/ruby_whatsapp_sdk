# frozen_string_literal: true
# typed: strict

module WhatsappSdk
  # This module allows client instantiating the client as a singleton like the following example:
  # WhatsappSdk.configure do |config|
  #   config.access_token = ACCESS_TOKEN
  # end
  #
  # The gem have access to the client through WhatsappSdk.configuration.client
  class Configuration
    extend T::Sig

    sig { returns(T.nilable(String)) }
    attr_accessor :access_token

    sig { params(access_token: T.nilable(String)).void }
    def initialize(access_token = nil)
      @access_token = access_token
    end

    sig { returns(T.nilable(WhatsappSdk::Api::Client)) }
    def client
      return unless access_token

      WhatsappSdk::Api::Client.new(T.must(access_token))
    end
  end
end

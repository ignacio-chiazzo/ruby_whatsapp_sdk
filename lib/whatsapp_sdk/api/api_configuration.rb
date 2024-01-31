# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Api
    module ApiConfiguration
      extend T::Sig

      API_VERSION = T.let("v19.0", String)
      API_URL = T.let("https://graph.facebook.com/#{API_VERSION}/", String)
    end
  end
end

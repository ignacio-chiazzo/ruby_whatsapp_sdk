# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Api
    module ApiConfiguration
      extend T::Sig

      DEFAULT_API_VERSION = T.let("v19.0", String)
      API_URL = T.let("https://graph.facebook.com", String)
    end
  end
end

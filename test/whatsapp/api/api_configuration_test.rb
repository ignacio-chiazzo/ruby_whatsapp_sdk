# typed: true
# frozen_string_literal: true

require 'test_helper'
require 'api/client'

module WhatsappSdk
  module Api
    class ClientTest < Minitest::Test
      def test_client_url
        assert_equal("https://graph.facebook.com/v19.0/",
                     "#{ApiConfiguration::API_URL}/#{ApiConfiguration::DEFAULT_API_VERSION}/")
      end

      def test_default_api_version
        assert_equal("v19.0", ApiConfiguration::DEFAULT_API_VERSION)
      end
    end
  end
end

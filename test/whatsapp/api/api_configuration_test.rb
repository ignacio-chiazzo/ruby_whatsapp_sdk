# typed: true
# frozen_string_literal: true

require 'test_helper'
require 'api/client'

module WhatsappSdk
  module Api
    class ClientTest < Minitest::Test
      def test_api_version
        assert_equal("https://graph.facebook.com/v16.0/", ApiConfiguration::API_URL)
      end

      def test_client_url
        assert_equal("v16.0", ApiConfiguration::API_VERSION)
      end
    end
  end
end

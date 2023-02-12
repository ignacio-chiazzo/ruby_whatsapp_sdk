# typed: true
# frozen_string_literal: true

require 'test_helper'
require_relative '../../../lib/whatsapp_sdk/api/client'

module WhatsappSdk
  module Api
    class ClientTest < Minitest::Test
      def test_api_version
        assert_equal(WhatsappSdk::Api::ApiConfiguration::API_URL, "https://graph.facebook.com/v16.0/")
      end

      def test_client_url
        assert_equal(WhatsappSdk::Api::ApiConfiguration::API_VERSION, "v16.0")
      end
    end
  end
end

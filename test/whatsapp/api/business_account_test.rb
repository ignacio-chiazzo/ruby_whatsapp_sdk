# typed: true
# frozen_string_literal: true

require 'api/business_account'
require 'api/client'

module WhatsappSdk
  module Api
    class BusinessAccountTest < Minitest::Test
      include(ErrorsHelper)

      def setup
        client = Client.new(ENV.fetch('WHATSAPP_ACCESS_TOKEN', nil))
        @business_account_api = BusinessAccount.new(client)
      end

      def test_get_handles_error_response
        VCR.use_cassette('business_account/details_handles_error_response') do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @business_account_api.get(123_123)
          end

          assert_equal(400, http_error.http_status)
          assert_unsupported_request_error_v2("get", "123123", "A4G-g6Sm5WRgY9eXdaKGpLJ", http_error.error_info)
        end
      end

      def test_get_accepts_fields
        fields = %w[analytics.start(1770606000).end(1770692400).granularity(HALF_HOUR)]
        VCR.use_cassette('business_account/details_accepts_fields') do
          business_account = @business_account_api.get(114_503_234_599_312, fields: fields)

          refute_nil business_account.id
          assert_equal({ 'granularity' => 'HALF_HOUR' }, business_account.analytics)
        end
      end

      def test_get_when_fields_not_provided_queries_default_fields
        VCR.use_cassette('business_account/when_fields_not_provided_queries_default_fields') do
          business_account = @business_account_api.get(114_503_234_599_312)

          assert_equal('114503234599312', business_account.id)
          assert_equal('Test Business Account', business_account.name)
        end
      end

      def test_update_returns_an_error_if_no_valid_params_provided
        assert_raises(ArgumentError) do
          @business_account_api.update(business_id: 114_503_234_599_312, params: { invalid_param: "value" })
        end
      end

      def test_update_returns_an_error_if_no_params_provided
        assert_raises(ArgumentError) do
          @business_account_api.update(business_id: 114_503_234_599_312, params: {})
        end
      end

      def test_update_returns_an_error_if_params_is_not_a_hash
        assert_raises(ArgumentError) do
          @business_account_api.update(business_id: 114_503_234_599_312, params: "invalid_params")
        end
      end
    end
  end
end

# typed: true
# frozen_string_literal: true

require 'api/business_profile'
require 'api/client'

module WhatsappSdk
  module Api
    class BusinessProfileTest < Minitest::Test
      include(ErrorsHelper)

      def setup
        client = Client.new(ENV.fetch('WHATSAPP_ACCESS_TOKEN', nil))
        @business_profile_api = BusinessProfile.new(client)
      end

      def test_get_handles_error_response
        VCR.use_cassette('business_profile/details_handles_error_response') do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @business_profile_api.get(123_123)
          end

          assert_equal(400, http_error.http_status)
          assert_unsupported_request_error_v2("get", "123123", "AYMXgC3SR8dC_HM7lrwoPOZ", http_error.error_info)
        end
      end

      def test_get_accepts_fields
        fields = %w[vertical]
        VCR.use_cassette('business_profile/details_accepts_fields') do
          business_profile = @business_profile_api.get(107_878_721_936_019, fields: fields)

          assert_equal("UNDEFINED", business_profile.vertical)
          assert_nil(business_profile.address)
        end
      end

      def test_get_queries_all_fields_by_default
        VCR.use_cassette('business_profile/details_queries_all_fields_by_default') do
          business_profile = @business_profile_api.get(107_878_721_936_019)

          assert_equal(business_profile_saved, business_profile)
        end
      end

      def test_update_returns_an_error_if_vertical_is_invalid
        params = { vertical: "invalid_vertical" }
        assert_raises(BusinessProfile::InvalidVertical) do
          @business_profile_api.update(phone_number_id: 123_123, params: params)
        end
      end

      def test_update_handles_error_response
        VCR.use_cassette('business_profile/update_handles_error_response') do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @business_profile_api.update(phone_number_id: 123_123, params: { about: "Hey there! I am using WhatsApp." })
          end

          assert_equal(400, http_error.http_status)
          assert_unsupported_request_error_v2("post", "123123", "Aqsz-RxXL8YZKhl3wBpoStg", http_error.error_info)
        end
      end

      def test_update_with_success_response
        VCR.use_cassette('business_profile/update_with_success_response') do
          params = {
            messaging_product: "whatsapp",
            address: "123, Main Street, New York, NY, 10001",
            description: "This is a description",
            email: "testing@gmail.com",
            websites: ["https://www.google.com"],
            vertical: "EDU"
          }
          assert(@business_profile_api.update(phone_number_id: 107_878_721_936_019, params: params))
        end
      end

      private

      def business_profile_saved
        Resource::BusinessProfile.from_hash(business_profile_saved_hash)
      end

      def business_profile_saved_hash
        {
          "about" => "A very cool business",
          "messaging_product" => "whatsapp",
          "address" => "123, Main Street, New York, NY, 10001",
          "description" => "This is a description",
          "email" => "testing@gmail.com",
          "profile_picture_url" => nil,
          "websites" => ["https://www.google.com/"],
          "vertical" => "EDU"
        }
      end
    end
  end
end

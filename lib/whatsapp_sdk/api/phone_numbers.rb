# frozen_string_literal: true

require_relative "request"
require_relative "response"

module WhatsappSdk
  module Api
    class PhoneNumbers < Request
      DEFAULT_FIELDS = %i[
        id is_official_business_account display_phone_number verified_name account_mode quality_rating
        certificate code_verification_status eligibility_for_api_business_global_search is_pin_enabled
        name_status new_name_status status search_visibility messaging_limit_tier
      ].join(",").freeze

      # Get list of registered numbers.
      #
      # @param business_id [Integer] Business Id.
      # @return [Api::Response] Response object.
      def list(business_id)
        response = send_request(
          http_method: "get",
          endpoint: "#{business_id}/phone_numbers?fields=#{DEFAULT_FIELDS}"
        )

        Api::Response.new(
          response: response,
          data_class_type: Api::Responses::PhoneNumbersDataResponse
        )
      end

      # Get the registered number.
      #
      # @param phone_number_id [Integer] The registered number we want to retrieve.
      # @return [Api::Response] Response object.
      def get(phone_number_id)
        response = send_request(
          http_method: "get",
          endpoint: "#{phone_number_id}?fields=#{DEFAULT_FIELDS}"
        )

        Api::Response.new(
          response: response,
          data_class_type: Api::Responses::PhoneNumberDataResponse
        )
      end

      # Register a phone number.
      #
      # @param phone_number_id [Integer] The registered number we want to retrieve.
      # @param pin [Integer] Pin of 6 digits.
      # @return [Api::Response] Response object.
      def register_number(phone_number_id, pin)
        response = send_request(
          http_method: "post",
          endpoint: "#{phone_number_id}/register",
          params: { messaging_product: 'whatsapp', pin: pin }
        )

        Api::Response.new(
          response: response,
          data_class_type: Api::Responses::PhoneNumberDataResponse
        )
      end

      # Deregister a phone number.
      #
      # @param phone_number_id [Integer] The registered number we want to retrieve.
      # @return [Api::Response] Response object.
      def deregister_number(phone_number_id)
        response = send_request(
          http_method: "post",
          endpoint: "#{phone_number_id}/deregister",
          params: {}
        )

        Api::Response.new(
          response: response,
          data_class_type: Api::Responses::PhoneNumberDataResponse
        )
      end

      # deprecated methods
      def registered_numbers(business_id)
        warn "[DEPRECATION] `registered_numbers` is deprecated. Please use `list` instead."
        list(business_id)
      end

      def registered_number(phone_number_id)
        warn "[DEPRECATION] `registered_number` is deprecated. Please use `get` instead."
        get(phone_number_id)
      end
    end
  end
end

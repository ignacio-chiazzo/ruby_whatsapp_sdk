# frozen_string_literal: true

require_relative "request"

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

        Api::Responses::PaginationRecords.new(
          records: parse_phone_numbers(response['data']),
          before: response['paging']['cursors']['before'],
          after: response['paging']['cursors']['after']
        )
      end

      # Get the registered number.
      #
      # @param phone_number_id [Integer] The registered number we want to retrieve.
      # @return [Resource::PhoneNumber] A PhoneNumber object.
      def get(phone_number_id)
        response = send_request(
          http_method: "get",
          endpoint: "#{phone_number_id}?fields=#{DEFAULT_FIELDS}"
        )

        Resource::PhoneNumber.from_hash(response)
      end

      # Add a phone number to a WABA. Verification and registration are separate calls.
      # @param business_id [String, Integer] WhatsApp Business Account ID.
      # @param country_code [String] Country calling code, without the plus sign.
      # @param phone_number [String] Phone number forwarded unchanged to Graph.
      # @param verified_name [String] Business display name submitted for review.
      # @return [Responses::IdResponse] Created phone number ID.
      # @raise [Responses::HttpResponseError] If Graph rejects the request.
      def add(business_id:, country_code:, phone_number:, verified_name:, raw_response: false)
        response = send_request(
          endpoint: "#{business_id}/phone_numbers",
          params: { cc: country_code, phone_number: phone_number, verified_name: verified_name },
          headers: { 'Content-Type' => 'application/json' },
          **(raw_response ? { raw_response: true } : {})
        )
        return response if raw_response

        Responses::IdResponse.new(response['id'])
      end

      # Request a verification code without automatically verifying or registering the number.
      # @param phone_number_id [String, Integer] Phone number ID.
      # @param code_method [String] SMS or VOICE.
      # @param language [String] Locale for code delivery, such as en_US.
      # @return [Boolean] Whether Graph accepted the request.
      # @raise [ArgumentError] If code_method is unsupported.
      # @raise [Responses::HttpResponseError] If Graph rejects the request.
      def request_code(phone_number_id:, code_method:, language:, raw_response: false)
        raise ArgumentError, 'code_method must be SMS or VOICE' unless %w[SMS VOICE].include?(code_method)

        response = send_request(
          endpoint: "#{phone_number_id}/request_code", params: { code_method: code_method, language: language },
          headers: { 'Content-Type' => 'application/json' },
          **(raw_response ? { raw_response: true } : {})
        )
        return response if raw_response

        Responses::SuccessResponse.success_response?(response: response)
      end

      # Verify ownership of a phone number. Register it separately with register_number.
      # @param phone_number_id [String, Integer] Phone number ID.
      # @param code [String] Verification code; pass a string to preserve leading zeroes.
      # @return [Boolean] Whether verification succeeded.
      # @raise [Responses::HttpResponseError] If Graph rejects the request.
      def verify_code(phone_number_id:, code:, raw_response: false)
        response = send_request(
          endpoint: "#{phone_number_id}/verify_code", params: { code: code },
          headers: { 'Content-Type' => 'application/json' },
          **(raw_response ? { raw_response: true } : {})
        )
        return response if raw_response

        Responses::SuccessResponse.success_response?(response: response)
      end

      # Register a phone number.
      #
      # @param phone_number_id [Integer] The registered number we want to retrieve.
      # @param pin [Integer] Pin of 6 digits.
      # @return [Boolean] Whether the registration was successful.
      def register_number(phone_number_id, pin, raw_response: false)
        response = send_request(
          http_method: "post",
          endpoint: "#{phone_number_id}/register",
          params: { messaging_product: 'whatsapp', pin: pin },
          **(raw_response ? { raw_response: true } : {})
        )
        return response if raw_response

        Api::Responses::SuccessResponse.success_response?(response: response)
      end

      # Deregister a phone number.
      #
      # @param phone_number_id [Integer] The registered number we want to retrieve.
      # @return [Boolean] Whether the deregistration was successful.
      def deregister_number(phone_number_id)
        response = send_request(
          http_method: "post",
          endpoint: "#{phone_number_id}/deregister",
          params: {}
        )

        Api::Responses::SuccessResponse.success_response?(response: response)
      end

      # Configure the public key used for Flow data exchange on this phone number.
      # @param phone_number_id [String, Integer] Business phone number ID.
      # @param business_public_key [String] PEM-encoded 2048-bit RSA public key, including newlines.
      # @return [Boolean] Whether the key was accepted.
      # @raise [Responses::HttpResponseError] If Graph rejects the request.
      def set_public_key(phone_number_id:, business_public_key:, raw_response: false)
        response = send_request(
          endpoint: "#{phone_number_id}/whatsapp_business_encryption",
          params: { business_public_key: business_public_key },
          headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
          **(raw_response ? { raw_response: true } : {})
        )
        return response if raw_response

        Responses::SuccessResponse.success_response?(response: response)
      end

      # @param phone_number_id [String, Integer] Business phone number ID.
      # @return [Hash] Raw Graph response; public key and signature status are nested in the data array.
      # @raise [Responses::HttpResponseError] If Graph rejects the request.
      def get_public_key(phone_number_id:)
        send_request(endpoint: "#{phone_number_id}/whatsapp_business_encryption", http_method: 'get')
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

      private

      def parse_phone_numbers(phone_numbers_data)
        phone_numbers_data.map do |phone_number|
          Resource::PhoneNumber.from_hash(phone_number)
        end
      end
    end
  end
end

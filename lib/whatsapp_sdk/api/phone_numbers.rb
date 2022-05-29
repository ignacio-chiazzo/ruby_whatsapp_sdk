# frozen_string_literal: true

require_relative "request"
require_relative "response"

module WhatsappSdk
  module Api
    class PhoneNumbers < Request
      def registered_numbers(business_id)
        response = send_request(
          http_method: "get",
          endpoint: "#{business_id}/phone_numbers"
        )

        WhatsappSdk::Api::Response.new(response: response,
                                       class_type: WhatsappSdk::Api::Responses::PhoneNumbersDataResponse)
      end

      def registered_number(phone_number_id)
        response = send_request(
          http_method: "get",
          endpoint: phone_number_id.to_s
        )

        WhatsappSdk::Api::Response.new(response: response,
                                       class_type: WhatsappSdk::Api::Responses::PhoneNumberDataResponse)
      end
    end
  end
end

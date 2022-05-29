require_relative "request"
require_relative "response"

module Whatsapp
  module Api
    class PhoneNumbers < Request
      def registered_numbers(business_id)
        response = send_request(
          http_method: "get",
          endpoint: "#{business_id}/phone_numbers",
        )

        Whatsapp::Api::Response.new(response: response, class_type: Whatsapp::Api::PhoneNumbersDataResponse)
      end

      def registered_number(phone_number_id)
        response = send_request(
          http_method: "get",
          endpoint: phone_number_id.to_s,
        )

        Whatsapp::Api::Response.new(response: response, class_type: Whatsapp::Api::PhoneNumberDataResponse)
      end
    end
  end
end

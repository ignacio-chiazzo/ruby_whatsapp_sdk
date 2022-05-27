require_relative "request"
require_relative "../resource/message"
require_relative "../resource/contact"

module Whatsapp
  module Api
    class PhoneNumbers < Request
      def registered_numbers(business_id)
        response = send_request(
          http_method: "get",
          endpoint: "#{business_id}/phone_numbers",
        )

        return print_error(response) unless valid?(response)
        # TODO: RETURN UNLESS VALID

        response.fetch("data").map do |phone_number|
          Whatsapp::Resource::PhoneNumberResponse.new(
            id: phone_number.fetch("id"),
            verified_name: phone_number.fetch("verified_name"),
            display_phone_number: phone_number.fetch("display_phone_number"),
            quality_rating: phone_number.fetch("quality_rating"),
          )
        end
      end

      def registered_number(phone_number_id)
        response = send_request(
          http_method: "get",
          endpoint: phone_number_id.to_s,
        )
        return print_error(response) unless valid?(response)
        # TODO: RETURN UNLESS VALID
        phone_number = parse_phone_number(response)
      end

      private 

      def parse_phone_number(response)
        ::Whatsapp::Resource::PhoneNumberResponse.new(
          id: response.fetch("id"),
          verified_name: response.fetch("verified_name"),
          display_phone_number: response.fetch("display_phone_number"),
          quality_rating: "D"
        )
      end

      def valid?(response)
        !response.key?("error")
      end

      def print_error(response)
        puts "ERROR: #{response.fetch("error").fetch("message")}"
      end
    end
  end
end

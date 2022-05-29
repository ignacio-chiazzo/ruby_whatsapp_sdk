require_relative "data_response"
require_relative "phone_number_data_response"

module Whatsapp
  module Api
    class PhoneNumbersDataResponse < DataResponse
      attr_reader :phone_numbers

      def initialize(response:)
        @phone_numbers = response['data']&.map { |phone_number| parse_phone_number(phone_number) }
      end
      
      def self.build_from_response(response:)
        return unless response["data"]

        self.new(response: response)
      end

      private

      def parse_phone_number(phone_number)
        Whatsapp::Api::PhoneNumberDataResponse.new(
          id: phone_number.dig("id"),
          verified_name: phone_number.dig("verified_name"),
          display_phone_number: phone_number.dig("display_phone_number"),
          quality_rating: phone_number.dig("quality_rating"),
        )
      end
    end
  end
end

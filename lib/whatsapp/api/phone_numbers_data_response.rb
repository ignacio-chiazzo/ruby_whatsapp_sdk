# frozen_string_literal: true

require_relative "data_response"
require_relative "phone_number_data_response"

module Whatsapp
  module Api
    class PhoneNumbersDataResponse < DataResponse
      attr_reader :phone_numbers

      def initialize(response)
        @phone_numbers = response['data']&.map { |phone_number| parse_phone_number(phone_number) }
        super(response)
      end

      def self.build_from_response(response:)
        return unless response["data"]

        new(response)
      end

      private

      def parse_phone_number(phone_number)
        Whatsapp::Api::PhoneNumberDataResponse.new(phone_number)
      end
    end
  end
end

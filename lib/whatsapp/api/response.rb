require_relative "../api/message_data_response"
require_relative "../api/phone_number_data_response"
require_relative "../api/phone_numbers_data_response"
require_relative "../api/error_response"

module Whatsapp
  module Api
    class Response
      attr_accessor :error, :data

      CLASS_TYPE = {
        message_data_response: Whatsapp::Api::MessageDataResponse,
        phone_number_data_response: Whatsapp::Api::PhoneNumberDataResponse,
        phone_numbers_data_response: Whatsapp::Api::PhoneNumbersDataResponse,
      }

      def initialize(response:, class_type: )
        @data = class_type.build_from_response(response: response)
        @error = ErrorResponse.build_from_response(response: response)
      end

      def ok?
        @error.nil?
      end

      def error?
        !!@error
      end
    end
  end
end
  
# frozen_string_literal: true

require_relative "responses/message_data_response"
require_relative "responses/phone_number_data_response"
require_relative "responses/phone_numbers_data_response"
require_relative "responses/error_response"

module WhatsappSdk
  module Api
    class Response
      attr_accessor :error, :data

      CLASS_TYPE = {
        message_data_response: Responses::MessageDataResponse,
        phone_number_data_response: Responses::PhoneNumberDataResponse,
        phone_numbers_data_response: Responses::PhoneNumbersDataResponse
      }.freeze

      def initialize(response:, class_type:)
        @data = class_type.build_from_response(response: response)
        @error = Responses::ErrorResponse.build_from_response(response: response)
      end

      # Whether or not the response is successful.
      def ok?
        @error.nil?
      end

      # Whether or not the response has an error.
      def error?
        !!@error
      end
    end
  end
end

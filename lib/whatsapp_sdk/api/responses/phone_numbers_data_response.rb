# frozen_string_literal: true
# typed: true

require_relative "data_response"
require_relative "phone_number_data_response"

module WhatsappSdk
  module Api
    module Responses
      class PhoneNumbersDataResponse < DataResponse
        attr_reader :phone_numbers

        sig { params(response: Hash).void }
        def initialize(response)
          @phone_numbers = response['data']&.map { |phone_number| parse_phone_number(phone_number) }
          super(response)
        end

        sig { override.params(response: Hash).returns(T.nilable(DataResponse)) }
        def self.build_from_response(response:)
          return unless response["data"]

          new(response)
        end

        private

        def parse_phone_number(phone_number)
          PhoneNumberDataResponse.new(phone_number)
        end
      end
    end
  end
end

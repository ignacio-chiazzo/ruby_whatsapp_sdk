# frozen_string_literal: true
# typed: strict

require_relative "data_response"
require_relative "phone_number_data_response"

module WhatsappSdk
  module Api
    module Responses
      class PhoneNumbersDataResponse < DataResponse
        sig { returns(T::Array[PhoneNumberDataResponse]) }
        attr_reader :phone_numbers

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response)
          @phone_numbers = T.let(
            response['data']&.map { |phone_number| parse_phone_number(phone_number) },
            T::Array[PhoneNumberDataResponse]
          )
          super(response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(PhoneNumbersDataResponse)) }
        def self.build_from_response(response:)
          return unless response["data"]

          new(response)
        end

        private

        sig { params(phone_number: T::Hash[T.untyped, T.untyped]).returns(PhoneNumberDataResponse) }
        def parse_phone_number(phone_number)
          PhoneNumberDataResponse.new(phone_number)
        end
      end
    end
  end
end

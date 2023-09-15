# typed: strict
# frozen_string_literal: true

require_relative "responses/message_data_response"
require_relative "responses/phone_number_data_response"
require_relative "responses/phone_numbers_data_response"
require_relative "responses/read_message_data_response"
require_relative "responses/message_error_response"
require_relative "responses/business_profile_data_response"

module WhatsappSdk
  module Api
    class Response
      extend T::Sig

      sig { returns(T.nilable(Api::Responses::ErrorResponse)) }
      attr_accessor :error

      sig { returns(T.nilable(Api::Responses::DataResponse)) }
      attr_accessor :data

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      attr_accessor :raw_response

      sig do
        params(
          response: T::Hash[T.untyped, T.untyped],
          data_class_type: T.class_of(Api::Responses::DataResponse),
          error_class_type: T.class_of(Api::Responses::ErrorResponse)
        ).void
      end
      def initialize(response:, data_class_type:, error_class_type: Responses::MessageErrorResponse)
        @raw_response = response
        @data = data_class_type.build_from_response(response: response)
        @error = error_class_type.build_from_response(response: response)
      end

      # @return [Boolean] Whether or not the response is successful.
      sig { returns(T::Boolean) }
      def ok?
        @error.nil?
      end

      # @return [Boolean] Whether or not the response has an error.
      sig { returns(T::Boolean) }
      def error?
        !!@error
      end
    end
  end
end

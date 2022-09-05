# frozen_string_literal: true
# typed: strict

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class ErrorResponse < DataResponse
        sig { returns(T.nilable(T::Boolean)) }
        attr_accessor :error

        sig { returns(T.nilable(Integer)) }
        attr_accessor :status

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response:)
          @error = response["error"]
          @status = response["status"]
          super(response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(ErrorResponse)) }
        def self.build_from_response(response:)
          return unless response["error"]

          new(response: response)
        end
      end
    end
  end
end

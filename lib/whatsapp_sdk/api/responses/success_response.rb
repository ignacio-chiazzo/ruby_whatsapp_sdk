# frozen_string_literal: true
# typed: strict

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class SuccessResponse < DataResponse
        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response:)
          @success = T.let(response["success"], T::Boolean)
          super(response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(SuccessResponse)) }
        def self.build_from_response(response:)
          return unless response["success"]

          new(response: response)
        end

        sig { returns(T::Boolean) }
        def success?
          @success
        end
      end
    end
  end
end

# frozen_string_literal: true
# typed: strict

require_relative "../request"
require_relative "data_response"
require_relative "../../resource/message"
require_relative "../../resource/contact_response"

module WhatsappSdk
  module Api
    module Responses
      class ReadMessageDataResponse < DataResponse
        extend T::Sig
        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response:)
          @success = T.let(response["success"], T::Boolean)
          super(response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(ReadMessageDataResponse)) }
        def self.build_from_response(response:)
          return if response["error"]

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

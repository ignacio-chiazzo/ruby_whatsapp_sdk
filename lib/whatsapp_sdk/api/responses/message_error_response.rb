# typed: strict
# frozen_string_literal: true

require_relative "error_response"

module WhatsappSdk
  module Api
    module Responses
      class MessageErrorResponse < ErrorResponse
        sig { returns(Integer) }
        attr_reader :code

        sig { returns(T.nilable(Integer)) }
        attr_reader :subcode

        sig { returns(T.nilable(String)) }
        attr_reader :message

        sig { returns(T.nilable(String)) }
        attr_reader :type

        sig { returns(T.nilable(String)) }
        attr_reader :data

        sig { returns(T.nilable(String)) }
        attr_reader :fbtrace_id

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response:)
          @code = T.let(response["code"], Integer)
          @subcode = T.let(response["error_subcode"], T.nilable(Integer))
          @message = T.let(response["message"], T.nilable(String))
          @type = T.let(response["type"], T.nilable(String))
          @data = T.let(response["data"], T.nilable(String))
          @fbtrace_id = T.let(response["fbtrace_id"], T.nilable(String))
          super(response: response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(MessageErrorResponse)) }
        def self.build_from_response(response:)
          error_response = response["error"]
          return unless error_response

          new(response: error_response)
        end
      end
    end
  end
end

# frozen_string_literal: true
# typed: strict

module WhatsappSdk
  module Api
    module Responses
      class DataResponse
        extend ::T::Sig
        extend ::T::Helpers

        abstract!

        sig { returns(T::Hash[T.untyped, T.untyped]) }
        attr_reader :raw_data_response

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response)
          @raw_data_response = response
        end

        sig { abstract.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(DataResponse)) }
        def self.build_from_response(response:); end
      end
    end
  end
end

# frozen_string_literal: true
# typed: strict

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class PhoneNumberDataResponse < DataResponse
        sig { returns(String) }
        attr_accessor :id

        sig { returns(String) }
        attr_accessor :verified_name

        sig { returns(String) }
        attr_accessor :display_phone_number

        sig { returns(String) }
        attr_accessor :quality_rating

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response)
          @id = T.let(response["id"], String)
          @verified_name = T.let(response["verified_name"], String)
          @display_phone_number = T.let(response["display_phone_number"], String)
          @quality_rating = T.let(response["quality_rating"], String)
          super(response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(PhoneNumberDataResponse)) }
        def self.build_from_response(response:)
          return unless response["id"]

          new(response)
        end
      end
    end
  end
end

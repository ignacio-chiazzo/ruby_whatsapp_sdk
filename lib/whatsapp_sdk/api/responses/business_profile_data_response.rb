# typed: strict
# frozen_string_literal: true

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class BusinessProfileDataResponse < DataResponse
        sig { returns(T.nilable(String)) }
        attr_accessor :about

        sig { returns(T.nilable(String)) }
        attr_accessor :address

        sig { returns(T.nilable(String)) }
        attr_accessor :description

        sig { returns(T.nilable(String)) }
        attr_accessor :email

        sig { returns(T.nilable(String)) }
        attr_accessor :messaging_product

        sig { returns(T.nilable(String)) }
        attr_accessor :profile_picture_url

        sig { returns(T.nilable(String)) }
        attr_accessor :vertical

        sig { returns(T::Array[String]) }
        attr_accessor :websites

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response)
          @about = T.let(response["data"][0]["about"], T.nilable(String))
          @address = T.let(response["data"][0]["address"], T.nilable(String))
          @description = T.let(response["data"][0]["description"], T.nilable(String))
          @email = T.let(response["data"][0]["email"], T.nilable(String))
          @messaging_product = T.let(response["data"][0]["messaging_product"], T.nilable(String))
          @profile_picture_url = T.let(response["data"][0]["profile_picture_url"], T.nilable(String))
          @vertical = T.let(response["data"][0]["vertical"], T.nilable(String))
          @websites = T.let(T.must(response["data"][0]["websites"]), T::Array[String])
          super(response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(BusinessProfileDataResponse)) }
        def self.build_from_response(response:)
          return nil if response['error']

          new(response)
        end
      end
    end
  end
end

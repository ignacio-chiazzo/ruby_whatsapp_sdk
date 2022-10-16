# frozen_string_literal: true
# typed: strict

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class BusinessProfileDataResponse < DataResponse
        sig { returns(String) }
        attr_accessor :about

        sig { returns(String) }
        attr_accessor :address

        sig { returns(String) }
        attr_accessor :description

        sig { returns(String) }
        attr_accessor :email

        sig { returns(String) }
        attr_accessor :messaging_product

        sig { returns(String) }
        attr_accessor :profile_picture_url

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response)
          # TODO: Verify the other data

          @about = T.let(response["data"][0]["about"], String)
          # @address = T.let(response["data"][0]["address"], String)
          # @description = T.let(response["data"][0]["description"], String)
          # @email = T.let(respons e["data"][0]["email"], String)
          @messaging_product = T.let(response["data"][0]["messaging_product"], String)
          # @profile_picture_url = T.let(response["data"][0]["profile_picture_url"], String)
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

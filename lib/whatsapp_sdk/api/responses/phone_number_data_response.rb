# typed: strict
# frozen_string_literal: true

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

        sig { returns(T::Boolean) }
        attr_accessor :is_pin_enabled, :is_official_business_account

        sig { returns(T.nilable(String)) }
        attr_accessor :account_mode, :certificate, :code_verification_status, :eligibility_for_api_business_global_search,
          :name_status, :new_name_status, :status, :search_visibility

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response)
          @id = T.let(response["id"], String)
          @verified_name = T.let(response["verified_name"], String)
          @display_phone_number = T.let(response["display_phone_number"], String)
          @quality_rating = T.let(response["quality_rating"], String)
          @is_pin_enabled = T.let(response["is_pin_enabled"], T::Boolean)
          @is_official_business_account = T.let(response["is_official_business_account"], T.nilable(T::Boolean))
          @account_mode = T.let(response["account_mode"], T.nilable(String))
          @certificate = T.let(response["certificate"], T.nilable(String))
          @code_verification_status = T.let(response["code_verification_status"], T.nilable(String))
          @eligibility_for_api_business_global_search = T.let(response["eligibility_for_api_business_global_search"], T.nilable(String))
          @name_status = T.let(response["name_status"], T.nilable(String))
          @new_name_status = T.let(response["new_name_status"], T.nilable(String))
          @status = T.let(response["status"], T.nilable(String))
          @search_visibility = T.let(response["search_visibility"], T.nilable(String))

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

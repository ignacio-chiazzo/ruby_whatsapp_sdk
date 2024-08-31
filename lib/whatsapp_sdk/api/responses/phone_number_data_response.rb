# frozen_string_literal: true

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class PhoneNumberDataResponse < DataResponse
        attr_accessor :id, :verified_name, :display_phone_number, :quality_rating, :is_pin_enabled,
          :is_official_business_account, :account_mode, :certificate, :code_verification_status,
          :eligibility_for_api_business_global_search, :name_status, :new_name_status, :status,
          :search_visibility, :messaging_limit_tier

        def initialize(response)
          @id = response["id"]
          @verified_name = response["verified_name"]
          @display_phone_number = response["display_phone_number"]
          @quality_rating = response["quality_rating"]
          @is_pin_enabled = response["is_pin_enabled"]
          @is_official_business_account = response["is_official_business_account"]
          @account_mode = response["account_mode"]
          @certificate = response["certificate"]
          @code_verification_status = response["code_verification_status"]
          @eligibility_for_api_business_global_search = response["eligibility_for_api_business_global_search"]
          @name_status = response["name_status"]
          @new_name_status = response["new_name_status"]
          @status = response["status"]
          @search_visibility = response["search_visibility"]
          @messaging_limit_tier = response["messaging_limit_tier"]

          super(response)
        end

        def self.build_from_response(response:)
          return unless response["id"]

          new(response)
        end
      end
    end
  end
end

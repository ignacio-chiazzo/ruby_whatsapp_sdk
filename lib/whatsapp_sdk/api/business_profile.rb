# frozen_string_literal: true
# typed: strict

require_relative "request"
require_relative "response"

module WhatsappSdk
  module Api
    class BusinessProfile < Request
      DEFAULT_FIELDS = 'about,address,description,email,profile_picture_url,websites,vertical'

      # Get the details of business profile.
      #
      # @param phone_number_id [Integer] Phone Number Id.
      # @return [WhatsappSdk::Api::Response] Response object.
      sig { params(phone_number_id: Integer).returns(WhatsappSdk::Api::Response) }
      def details(phone_number_id)
        response = send_request(
          http_method: "get",
          endpoint: "#{phone_number_id}/whatsapp_business_profile?fields=#{DEFAULT_FIELDS}"
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::BusinessProfileDataResponse
        )
      end

      # Update the details of business profile.
      #
      # @param phone_number_id [Integer] Phone Number Id.
      # @param params [Hash] Params to update.
      # @return [WhatsappSdk::Api::Response] Response object.
      def update(phone_number_id:, params:)
        # this is a required field
        params.merge!({ messaging_product: 'whatsapp' })

        response = send_request(
          http_method: "post",
          endpoint: "#{phone_number_id}/whatsapp_business_profile",
          params: params
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::SuccessResponse
        )
      end
    end
  end
end

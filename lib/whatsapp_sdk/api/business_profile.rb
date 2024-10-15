# frozen_string_literal: true

require_relative "request"
require_relative "response"
require_relative "../resource/business_profile"

module WhatsappSdk
  module Api
    class BusinessProfile < Request
      DEFAULT_FIELDS = 'about,address,description,email,profile_picture_url,websites,vertical'

      class InvalidVertical < StandardError
        attr_accessor :message

        def initialize(vertical:)
          @message = "invalid vertical #{vertical}. See the supported types in the official documentation " \
                     "https://developers.facebook.com/docs/whatsapp/cloud-api/reference/business-profiles"
          super
        end
      end

      # Get the details of business profile.
      #
      # @param phone_number_id [Integer] Phone Number Id.
      # @return [Resource::BusinessProfile] Response object.
      def get(phone_number_id, fields: nil)
        fields = if fields
                   fields.join(',')
                 else
                   DEFAULT_FIELDS
                 end

        response = send_request(
          http_method: "get",
          endpoint: "#{phone_number_id}/whatsapp_business_profile?fields=#{fields}"
        )

        # In the future it might have multiple business profiles.
        Resource::BusinessProfile.from_hash(response["data"][0])
      end

      def details(phone_number_id, fields: nil)
        warn "[DEPRECATION] `details` is deprecated. Please use `get` instead."
        get(phone_number_id, fields: fields)
      end

      # Update the details of business profile.
      #
      # @param phone_number_id [Integer] Phone Number Id.
      # @param params [Hash] Params to update.
      # @return [Boolean] Whether the update was successful.
      def update(phone_number_id:, params:)
        params[:messaging_product] = 'whatsapp' # messaging_products is a required field
        return raise InvalidVertical.new(vertical: params[:vertical]) unless valid_vertical?(params)

        response = send_request(
          http_method: "post",
          endpoint: "#{phone_number_id}/whatsapp_business_profile",
          params: params
        )

        Api::Responses::SuccessResponse.success_response?(response: response)
      end

      private

      def valid_vertical?(params)
        return true unless params[:vertical]

        WhatsappSdk::Resource::BusinessProfile::VERTICAL_VALUES.include?(params[:vertical])
      end
    end
  end
end

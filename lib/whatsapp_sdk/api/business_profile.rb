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
      # @return [Api::Response] Response object.
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

        Api::Response.new(
          response: response,
          data_class_type: Api::Responses::BusinessProfileDataResponse
        )
      end

      def details(phone_number_id, fields: nil)
        warn "[DEPRECATION] `details` is deprecated. Please use `get` instead."
        get(phone_number_id, fields: fields)
      end

      # Update the details of business profile.
      #
      # @param phone_number_id [Integer] Phone Number Id.
      # @param params [Hash] Params to update.
      # @return [Api::Response] Response object.
      def update(phone_number_id:, params:)
        # this is a required field
        params[:messaging_product] = 'whatsapp'
        return raise InvalidVertical.new(vertical: params[:vertical]) unless valid_vertical?(params)

        response = send_request(
          http_method: "post",
          endpoint: "#{phone_number_id}/whatsapp_business_profile",
          params: params
        )

        Api::Response.new(
          response: response,
          data_class_type: Api::Responses::SuccessResponse
        )
      end

      private

      def valid_vertical?(params)
        return true unless params[:vertical]

        WhatsappSdk::Resource::BusinessProfile::VERTICAL_VALUES.include?(params[:vertical])
      end
    end
  end
end

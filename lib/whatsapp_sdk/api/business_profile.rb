# typed: strict
# frozen_string_literal: true

require_relative "request"
require_relative "response"
require_relative "../resource/business_profile"

module WhatsappSdk
  module Api
    class BusinessProfile < Request
      DEFAULT_FIELDS = 'about,address,description,email,profile_picture_url,websites,vertical'

      class InvalidVertical < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_accessor :message

        sig { params(vertical: String).void }
        def initialize(vertical:)
          @message = T.let("invalid vertical #{vertical}. See the supported types in the official documentation " \
                           "https://developers.facebook.com/docs/whatsapp/cloud-api/reference/business-profiles", String)
          super
        end
      end

      # Get the details of business profile.
      #
      # @param phone_number_id [Integer] Phone Number Id.
      # @return [Api::Response] Response object.
      sig { params(phone_number_id: Integer, fields: T.nilable(T::Array[String])).returns(Api::Response) }
      def details(phone_number_id, fields: nil)
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
          response: T.must(response),
          data_class_type: Api::Responses::BusinessProfileDataResponse
        )
      end

      # Update the details of business profile.
      #
      # @param phone_number_id [Integer] Phone Number Id.
      # @param params [Hash] Params to update.
      # @return [Api::Response] Response object.
      sig do
        params(
          phone_number_id: Integer, params: T::Hash[T.untyped, T.untyped]
        ).returns(Api::Response)
      end
      def update(phone_number_id:, params:)
        # this is a required field
        params[:messaging_product] = 'whatsapp'
        raise InvalidVertical.new(vertical: params[:vertical]) unless valid_vertical?(params)

        response = send_request(
          http_method: "post",
          endpoint: "#{phone_number_id}/whatsapp_business_profile",
          params: params
        )

        Api::Response.new(
          response: T.must(response),
          data_class_type: Api::Responses::SuccessResponse
        )
      end

      private

      sig { params(params: T::Hash[T.untyped, T.untyped]).returns(T::Boolean) }
      def valid_vertical?(params)
        return true unless params[:vertical]

        WhatsappSdk::Resource::BusinessProfile::VERTICAL_VALUES.include?(params[:vertical])
      end
    end
  end
end

# frozen_string_literal: true

require_relative "request"
require_relative "../resource/business_account"

module WhatsappSdk
  module Api
    class BusinessAccount < Request
      DEFAULT_FIELDS = 'id,name'

      # Get the details of business account.
      #
      # @param business_id [Integer] Business Account Id.
      # @param fields [Array<String>] Optional list of fields to include in the response. Defaults to 'id,name'.
      # @return [Resource::BusinessAccount] Response object.
      def get(business_id, fields: nil)
        fields = if fields
                   fields.join(',')
                 else
                   DEFAULT_FIELDS
                 end

        response = send_request(
          http_method: "get",
          endpoint: "#{business_id}?fields=#{fields}"
        )

        Resource::BusinessAccount.from_hash(response)
      end

      # Update the details of business account.
      #
      # @param business_id [Integer] Business Account Id.
      # @param params [Hash] Params to update. The possible attributes to update are: `name`, `timezone_id`.
      # @return [Boolean] Whether the update was successful.
      def update(business_id:, params:)
        raise ArgumentError, "Params must be a hash." unless params.is_a?(Hash)

        # Only name and timezone_id can be updated. If other keys are present, they will be ignored.
        filtered_params = params.slice(:name, :timezone_id, 'name', 'timezone_id')

        if filtered_params.empty?
          raise ArgumentError, "No valid parameters provided. Only 'name' and 'timezone_id' can be updated."
        end

        response = send_request(
          http_method: "post",
          endpoint: business_id.to_s,
          params: filtered_params
        )

        Api::Responses::SuccessResponse.success_response?(response: response)
      end
    end
  end
end

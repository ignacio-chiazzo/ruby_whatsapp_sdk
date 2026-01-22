# frozen_string_literal: true

require_relative "request"
require_relative "../resource/languages"

module WhatsappSdk
  module Api
    class Templates < Request
      DEFAULT_HEADERS = { 'Content-Type' => 'application/json' }.freeze

      class InvalidCategoryError < StandardError
        attr_reader :category

        def initialize(category:)
          @category = category

          super("Invalid Category. The possible values are: AUTHENTICATION, MARKETING and UTILITY.")
        end
      end

      # Create a template
      #
      # @param business_id [Integer] Business Id.
      # @param name [String] the template's name.
      # @param category [String] the template's category. Possible values: AUTHENTICATION, MARKETING, UTILITY.
      # @param language [String] Template language and locale code (e.g. en_US).
      #  See the list of possible languages https://developers.facebook.com/docs/whatsapp/api/messages/message-templates
      # @param components_json [Component] Components that make up the template. See the list of possible components:
      #   https://developers.facebook.com/docs/whatsapp/business-management-api/message-templates/components
      # @param allow_category_change [Boolean] Optional Allow category change.
      # @param parameter_format [String] Optional Parameter format. Possible values: named, positional.
      # Set to true to allow us to assign a category based on the template guidelines and the template's contents.
      #   This can prevent your template from being rejected for miscategorization.
      # @return [Template] Template object.
      def create(
        business_id:, name:, category:, language:, components_json: nil, allow_category_change: nil,
        parameter_format: nil
      )
        unless WhatsappSdk::Resource::Template::Category.valid?(category)
          raise InvalidCategoryError.new(category: category)
        end

        unless WhatsappSdk::Resource::Languages.available?(language)
          raise WhatsappSdk::Resource::Errors::InvalidLanguageError.new(language: language)
        end

        if parameter_format && !WhatsappSdk::Resource::ParameterObject::Format.valid?(parameter_format)
          raise WhatsappSdk::Resource::Errors::InvalidParameterFormatError.new(format: parameter_format)
        end

        params = {
          name: name,
          category: category,
          language: language,
          components: components_json
        }
        params["allow_category_change"] = allow_category_change if allow_category_change
        params["parameter_format"] = parameter_format if parameter_format

        response = send_request(
          endpoint: "#{business_id}/message_templates",
          http_method: "post",
          params: params,
          headers: DEFAULT_HEADERS
        )

        Resource::Template.from_hash(response)
      end

      # Get templates
      #
      # @param business_id [Integer] The business ID.
      # @param limit [Integer] Optional. Number of templates to return in a single page.
      # @return [Template] Pagination Record containing an array of Template objects.
      def list(business_id:, limit: 100)
        params = {}
        params["limit"] = limit if limit

        response = send_request(
          endpoint: "#{business_id}/message_templates",
          http_method: "get",
          params: params
        )

        Api::Responses::PaginationRecords.new(
          records: parse_templates(response['data']),
          before: response.dig('paging','cursors','before'),
          after: response.dig('paging','cursors','after')
        )
      end

      def templates(business_id:)
        warn "[DEPRECATION] `templates` is deprecated. Please use `list` instead."
        list(business_id: business_id)
      end

      # Get Message Template Namespace
      # The message template namespace is required to send messages using the message templates.
      #
      # @param business_id [Integer] The business ID.
      # @return [MessageTemplateNamespace] MessageTemplateNamespace object.
      def get_message_template_namespace(business_id:)
        response = send_request(
          endpoint: business_id.to_s,
          http_method: "get",
          params: { "fields" => "message_template_namespace" }
        )

        WhatsappSdk::Resource::MessageTemplateNamespace.from_hash(response)
      end

      # Edit Template
      #
      # Editing a template replaces its old contents entirely, so include any components you wish
      # to preserve as well as components you wish to update using the components parameter.
      #
      # Message templates can only be edited when in an Approved, Rejected, or Paused state.
      #
      # @param id [String] Required. The message_template-id.
      # @param components_json [Json] Components that make up the template..
      # @return [Boolean] Whether the update was successful.
      def update(template_id:, category: nil, components_json: nil)
        if category && !WhatsappSdk::Resource::Template::Category.valid?(category)
          raise InvalidCategoryError.new(category: category)
        end

        params = {}
        params[:components] = components_json if components_json
        params[:category] = category if category

        response = send_request(
          endpoint: template_id.to_s,
          http_method: "post",
          params: params,
          headers: { "Content-Type" => "application/json" }
        )

        Api::Responses::SuccessResponse.success_response?(response: response)
      end

      # Delete Template
      #
      # Deleting a template by name deletes all templates that match that name
      # (meaning templates with the same name but different languages will also be deleted).
      # To delete a template by ID, include the template's ID along with its name in your request;
      # only the template with the matching template ID will be deleted.
      #
      # @param business_id [Integer] Required. The business ID.
      # @param name [String] Required. The template's name.
      # @param hsm_id [String] Optional. The template's id.
      #
      # @return [Boolean] Whether the deletion was successful.
      def delete(business_id:, name:, hsm_id: nil)
        params = { name: name }
        params[:hsm_id] = hsm_id if hsm_id

        response = send_request(
          endpoint: "#{business_id}/message_templates",
          http_method: "delete",
          params: params
        )

        Api::Responses::SuccessResponse.success_response?(response: response)
      end

      private

      def parse_templates(templates_data)
        templates_data.map do |template|
          Resource::Template.from_hash(template)
        end
      end
    end
  end
end

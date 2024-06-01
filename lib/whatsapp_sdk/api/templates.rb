# typed: strict
# frozen_string_literal: true

require_relative "request"
require_relative "response"
require_relative 'responses/success_response'
require_relative 'responses/message_template_namespace_data_response'
require_relative 'responses/generic_error_response'
require_relative 'responses/template_data_response'
require_relative 'responses/templates_data_response'
require_relative "../resource/languages"

module WhatsappSdk
  module Api
    class Templates < Request
      DEFAULT_HEADERS = T.let({ 'Content-Type' => 'application/json' }.freeze, T::Hash[T.untyped, T.untyped])

      class InvalidCategoryError < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :category

        sig { params(category: String).void }
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
      # Set to true to allow us to assign a category based on the template guidelines and the template's contents.
      #   This can prevent your template from being rejected for miscategorization.
      # @return [Response] Response object.
      sig do
        params(
          business_id: Integer,
          name: String,
          category: String,
          language: String,
          components_json: T.nilable(T::Array[T::Hash[T.untyped, T.untyped]]),
          allow_category_change: T.nilable(T::Boolean)
        ).returns(Response)
      end
      def create(
        business_id:, name:, category:, language:, components_json: nil, allow_category_change: nil
      )
        unless WhatsappSdk::Resource::Template::Category.try_deserialize(category)
          raise InvalidCategoryError.new(category: category)
        end

        unless WhatsappSdk::Resource::Languages.available?(language)
          raise WhatsappSdk::Resource::Errors::InvalidLanguageError.new(language: language)
        end

        params = {
          name: name,
          category: category,
          language: language,
          components: components_json
        }
        params["allow_category_change"] = allow_category_change if allow_category_change

        response = send_request(
          endpoint: "#{business_id}/message_templates",
          http_method: "post",
          params: params,
          headers: DEFAULT_HEADERS
        )

        Response.new(
          response: T.must(response),
          data_class_type: Responses::TemplateDataResponse,
          error_class_type: Responses::GenericErrorResponse
        )
      end

      # Get templates
      #
      # @param business_id [Integer] The business ID.
      # @param limit [Integer] Optional. Number of templates to return in a single page.
      # @return [Response] Response object.
      sig { params(business_id: Integer, limit: T.nilable(Integer)).returns(Response) }
      def templates(business_id:, limit: 100)
        params = {}
        params["limit"] = limit if limit

        response = send_request(
          endpoint: "#{business_id}/message_templates",
          http_method: "get",
          params: params
        )

        Response.new(
          response: T.must(response),
          data_class_type: Responses::TemplatesDataResponse,
          error_class_type: Responses::GenericErrorResponse
        )
      end

      # Get Message Template Namespace
      # The message template namespace is required to send messages using the message templates.
      #
      # @param business_id [Integer] The business ID.
      # @return [Response] Response object.
      sig { params(business_id: Integer).returns(Response) }
      def get_message_template_namespace(business_id:)
        response = send_request(
          endpoint: business_id.to_s,
          http_method: "get",
          params: { "fields" => "message_template_namespace" }
        )

        Response.new(
          response: T.must(response),
          data_class_type: Responses::MessageTemplateNamespaceDataResponse,
          error_class_type: Responses::GenericErrorResponse
        )
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
      # return [Response] Response object.
      sig do
        params(
          template_id: String,
          category: T.nilable(String),
          components_json: T.nilable(T::Hash[T.untyped, T.untyped])
        ).returns(Response)
      end
      def update(template_id:, category: nil, components_json: nil)
        if category && !WhatsappSdk::Resource::Template::Category.try_deserialize(category)
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

        Response.new(
          response: T.must(response),
          data_class_type: Responses::SuccessResponse,
          error_class_type: Responses::GenericErrorResponse
        )
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
      # @return [Response] Response object.
      sig do
        params(
          business_id: Integer,
          name: String,
          hsm_id: T.nilable(String)
        ).returns(Response)
      end
      def delete(business_id:, name:, hsm_id: nil)
        params = { name: name }
        params[:hsm_id] = hsm_id if hsm_id

        response = send_request(
          endpoint: "#{business_id}/message_templates",
          http_method: "delete",
          params: params
        )

        Response.new(
          response: T.must(response),
          data_class_type: Responses::SuccessResponse,
          error_class_type: Responses::GenericErrorResponse
        )
      end
    end
  end
end

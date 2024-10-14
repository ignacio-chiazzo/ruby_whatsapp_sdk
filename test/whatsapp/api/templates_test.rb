# typed: true
# frozen_string_literal: true

require "test_helper"
require 'api/templates'
require 'api/client'
require 'api/messages'
require 'api/responses/template_data_response'
require 'resource/errors'

module WhatsappSdk
  module Api
    class TemplatesTest < Minitest::Test
      include(ErrorsHelper)
      include(ApiResponseHelper)

      def setup
        client = Client.new(ENV.fetch('WHATSAPP_ACCESS_TOKEN', nil))
        @messages_api = Messages.new(client)
        @templates_api = Templates.new(client)
      end

      ##### CREATE
      def test_create_a_template_raises_an_error_when_category_is_invalid
        error = assert_raises(Templates::InvalidCategoryError) do
          @templates_api.create(
            business_id: 123_456,
            name: "seasonal_promotion",
            language: "en_US",
            category: "RANDOM"
          )
        end

        assert_equal("Invalid Category. The possible values are: AUTHENTICATION, MARKETING and UTILITY.", error.message)
      end

      def test_create_a_template_raises_an_error_when_the_languge_is_invalid
        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidLanguageError) do
          @templates_api.create(
            business_id: 123_456,
            name: "seasonal_promotion",
            language: "en_invalid",
            category: "MARKETING"
          )
        end

        url = "https://developers.facebook.com/docs/whatsapp/api/messages/message-templates"
        assert_equal("Invalid language. Check the available languages in #{url}.", error.message)
      end

      def test_create_a_template_with_valid_params_and_components
        VCR.use_cassette('templates/create_a_template_with_valid_params_and_components') do
          new_template = @templates_api.create(
            business_id: 114_503_234_599_312, name: "seasonal_promotion", language: "nl", category: "MARKETING",
            components_json: basic_components_json, allow_category_change: true
          )

          assert_ok_response(new_template)
          assert_equal(Responses::TemplateDataResponse, new_template.data.class)
          assert_equal("MARKETING", new_template.data.template.category)
          assert_equal("PENDING", new_template.data.template.status)
          assert(new_template.data.template.id)
        end
      end

      ##### GET Templates
      def test_get_templates
        VCR.use_cassette('templates/get_templates') do
          templates_response = @templates_api.templates(business_id: 114_503_234_599_312)
          assert_ok_response(templates_response)
          assert_equal(Responses::TemplatesDataResponse, templates_response.data.class)
          assert_equal(25, templates_response.data.templates.size)
          assert_equal(Responses::TemplateDataResponse, templates_response.data.templates.first.class)
        end
      end

      def test_get_templates_when_an_error_is_returned
        VCR.use_cassette('templates/get_templates_when_an_error_is_returned') do
          templates_response = @templates_api.templates(business_id: 123_456)
          assert_unsupported_request_error("get", templates_response, "123456", "AhvemSTIjTs-WJikZKj0mLu")
        end
      end

      ##### GET Message Template namespace
      def test_get_template_namespace
        VCR.use_cassette('templates/get_template_namespace') do
          templates_response = @templates_api.get_message_template_namespace(business_id: 114_503_234_599_312)

          assert_ok_response(templates_response)
          assert_equal(Responses::MessageTemplateNamespaceDataResponse, templates_response.data.class)
          assert_equal("114503234599312", templates_response.data.id)
          assert_equal("ffac72fb_6591_4cb3_bb24_0c33a6633999", templates_response.data.message_template_namespace)
        end
      end

      def test_get_template_namespace_when_an_error_is_returned
        VCR.use_cassette('templates/get_template_namespace_when_an_error_is_returned') do
          fake_business_id = 123_456
          templates_response = @templates_api.get_message_template_namespace(business_id: fake_business_id)
          assert_unsupported_request_error("get", templates_response, "123456", "A8nD588C9Qpiid9YWpnwzYB")
        end
      end

      ##### Update Message Template
      def test_update_a_template_raises_an_error_when_category_is_invalid
        error = assert_raises(Templates::InvalidCategoryError) do
          @templates_api.update(template_id: 123_456, category: "INVALID_CATEGORY")
        end

        assert_equal("Invalid Category. The possible values are: AUTHENTICATION, MARKETING and UTILITY.", error.message)
      end

      def test_update_a_template_with_components_and_category
        VCR.use_cassette('templates/update_a_template_with_components_and_category') do
          template_response = @templates_api.update(
            template_id: "1713674996085293", components_json: basic_components_json
          )

          assert_ok_success_response(template_response)
        end
      end

      ##### Delete Message Template
      def test_delete_template_by_name
        VCR.use_cassette('templates/delete_template_by_name') do
          response = @templates_api.delete(business_id: 114_503_234_599_312, name: "seasonal_promotion")
          assert_ok_success_response(response)
        end
      end

      def test_delete_template_by_id
        VCR.use_cassette('templates/delete_template_by_id') do
          response = @templates_api.delete(business_id: 114_503_234_599_312, name: "seasonal_promotion",
                                           hsm_id: 1_075_472_707_447_727)
          assert_ok_success_response(response)
        end
      end

      def test_delete_template_with_error_response
        VCR.use_cassette('templates/delete_template_with_error_response') do
          response = @templates_api.delete(business_id: 114_503_234_599_312, name: "fake name")
          assert_error_response(
            {
              code: 100,
              error_subcode: 2_593_002,
              message: "Invalid parameter",
              fbtrace_id: "Ax5tIkALJCP4l5S8jbPvW2n"
            },
            response
          )
        end
      end

      private

      def assert_ok_success_response(response)
        assert_ok_response(response)
        assert_equal(Responses::SuccessResponse, response.data.class)
        assert_predicate(response.data, :success?)
      end

      def basic_components_json
        [
          {
            type: "BODY",
            text: "Thank you for your order, {{1}}! Your confirmation number is {{2}}. " \
                  "If you have any questions, please use the buttons below to contact support. " \
                  "Thank you for being a customer!",
            example: { body_text: [%w[Ignacio 860198-230332]] }
          },
          {
            type: "BUTTONS",
            buttons: [
              {
                type: "PHONE_NUMBER",
                text: "Call",
                phone_number: "59898400766"
              },
              {
                type: "URL",
                text: "Contact Support",
                url: "https://www.luckyshrub.com/support"
              }
            ]
          }
        ]
      end
    end
  end
end

# typed: true
# frozen_string_literal: true

require "test_helper"
require 'api/templates'
require 'api/client'
require 'api/messages'
require 'api/responses/template_data_response'

module WhatsappSdk
  module Api
    class TemplatesTest < Minitest::Test
      include(ErrorsHelper)

      def setup
        client = Client.new("test_token")
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
        error = assert_raises(Resource::Errors::InvalidLanguageError) do
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

      def test_create_a_template_with_valid_params_and_no_components
        @templates_api.expects(:send_request).with(
          http_method: "post",
          endpoint: "123456/message_templates",
          params: {
            name: "seasonal_promotion",
            category: "MARKETING",
            language: "en_US",
            components: []
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_template_response)

        template_response = @templates_api.create(
          business_id: 123_456,
          name: "seasonal_promotion",
          language: "en_US",
          category: "MARKETING",
          components_json: []
        )

        assert_templates_mock_response(valid_template_response, template_response.data)
        assert_predicate(template_response, :ok?)
        assert_ok_response(template_response)
      end

      def test_create_a_template_with_valid_params_and_components
        components_json = [{
          type: "header",
          parameters: [
            {
              type: "image",
              image: {
                link: "http(s)://URL"
              }
            }
          ]
        }]

        @templates_api.expects(:send_request).with(
          http_method: "post",
          endpoint: "123456/message_templates",
          params: {
            name: "seasonal_promotion",
            category: "MARKETING",
            language: "en_US",
            components: components_json
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_template_response)

        template_response = @templates_api.create(
          business_id: 123_456,
          name: "seasonal_promotion",
          language: "en_US",
          category: "MARKETING",
          components_json: components_json
        )

        assert_templates_mock_response(valid_template_response, template_response.data)
        assert_predicate(template_response, :ok?)
        assert_ok_response(template_response)
      end

      ##### GET Templates
      def test_get_templates
        @templates_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "123456/message_templates",
          params: { "limit" => 100 }
        ).returns(mock_example_templates_response)

        templates_response = @templates_api.templates(business_id: 123_456)

        assert_ok_response(templates_response)
        assert_equal(Responses::TemplatesDataResponse, templates_response.data.class)
        assert_equal(1, templates_response.data.templates.size)
        assert_templates_mock_response(mock_example_templates_response["data"][0],
                                       templates_response.data.templates.first)
      end

      def test_get_templates_when_an_error_is_returned
        expected_response = mock_error_response(api: @messages_api)
        @templates_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "123456/message_templates",
          params: { "limit" => 100 }
        ).returns(expected_response)

        templates_response = @templates_api.templates(business_id: 123_456)
        assert_mock_error_response(expected_response, templates_response)
      end

      ##### GET Message Template namespace
      def test_get_template_namespace
        expected_response = mock_example_template_response("145145", "abcd_1234_gfhd_1234")

        @templates_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "123456",
          params: { "fields" => "message_template_namespace" }
        ).returns(expected_response)

        templates_response = @templates_api.get_message_template_namespace(business_id: 123_456)
        assert_ok_response(templates_response)
        assert_equal(Responses::MessageTemplateNamespaceDataResponse, templates_response.data.class)
        assert_equal("145145", templates_response.data.id)
        assert_equal("abcd_1234_gfhd_1234", templates_response.data.message_template_namespace)
      end

      def test_get_template_namespace_when_an_error_is_returned
        expected_response = mock_error_response(api: @messages_api)

        @templates_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "123456",
          params: { "fields" => "message_template_namespace" }
        ).returns(expected_response)

        templates_response = @templates_api.get_message_template_namespace(business_id: 123_456)
        assert_mock_error_response(expected_response, templates_response)
      end

      ##### Update Message Template
      def test_update_a_template_raises_an_error_when_category_is_invalid
        error = assert_raises(Templates::InvalidCategoryError) do
          @templates_api.update(template_id: 123_456, category: "INVALID_CATEGORY")
        end

        assert_equal("Invalid Category. The possible values are: AUTHENTICATION, MARKETING and UTILITY.", error.message)
      end

      def test_update_a_template_with_components_and_category
        components_json = {
          header: {
            type: "header",
            parameters: [
              {
                type: "image",
                image: {
                  link: "http(s)://URL"
                }
              }
            ]
          }
        }

        template_id = "123456"
        new_category = "MARKETING"

        @templates_api.expects(:send_request).with(
          http_method: "post",
          endpoint: template_id,
          params: { components: components_json, category: new_category },
          headers: { "Content-Type" => "application/json" }
        ).returns({ "success" => true })

        template_response = @templates_api.update(
          template_id: template_id,
          category: "MARKETING",
          components_json: components_json
        )

        assert_equal(Response, template_response.class)
        assert_equal(Responses::SuccessResponse, template_response.data.class)
        assert_nil(template_response.error)
        assert_predicate(template_response, :ok?)
        assert_predicate(template_response.data, :success?)
      end

      ##### Delete Message Template
      def test_delete_template_by_name
        business_id = 123_456
        name = "seasonal_promotion"

        @templates_api.expects(:send_request).with(
          http_method: "delete",
          endpoint: "#{business_id}/message_templates",
          params: { name: name }
        ).returns({ "success" => true })

        response = @templates_api.delete(business_id: business_id, name: name)

        validate_sucess_data_response(response)
      end

      def test_delete_template_by_id
        business_id = 123_456
        name = "seasonal_promotion"
        hsm_id = "987654321"

        @templates_api.expects(:send_request).with(
          http_method: "delete",
          endpoint: "#{business_id}/message_templates",
          params: {
            name: name,
            hsm_id: hsm_id
          }
        ).returns({ "success" => true })

        response = @templates_api.delete(business_id: business_id, name: name, hsm_id: hsm_id)

        validate_sucess_data_response(response)
      end

      def test_delete_template_with_error_response
        business_id = 123_456
        name = "seasonal_promotion"

        @templates_api.expects(:send_request).with(
          http_method: "delete",
          endpoint: "#{business_id}/message_templates",
          params: { name: name }
        ).returns(generic_error_response)

        response = @templates_api.delete(business_id: business_id, name: name)
        assert_error_response(generic_error_response, response)
      end

      private

      def validate_sucess_data_response(response)
        assert_ok_response(response)
        assert_equal(Responses::SuccessResponse, response.data.class)
        assert_predicate(response.data, :success?)
      end

      def mock_response
        @templates_api.stubs(:send_request).returns(valid_template_response)
        valid_template_response
      end

      def assert_templates_mock_response(expected_template_response, template_response)
        [
          [Responses::TemplateDataResponse, template_response.class],
          [expected_template_response["id"], template_response.template.id],
          [expected_template_response["status"], template_response.template.status.serialize],
          [expected_template_response["category"], template_response.template.category.serialize],
          [expected_template_response["language"], template_response.template.language],
          [expected_template_response["name"], template_response.template.name],
          [expected_template_response["components"], template_response.template.components_json]
        ].each do |expected, actual|
          if expected.nil?
            assert_nil(actual)
          else
            assert_equal(expected, actual)
          end
        end
      end

      def assert_ok_response(response)
        assert_equal(Response, response.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
      end

      def valid_template_response
        @valid_template_response ||= {
          "id" => "123456",
          "status" => "PENDING",
          "category" => "MARKETING"
        }
      end

      def mock_example_template_response(id = "123456", message_template_namespace = "abcd_1234_gfhd_1234")
        {
          "message_template_namespace" => message_template_namespace,
          "id" => id
        }
      end

      def mock_example_templates_response
        {
          "data" => [
            {
              "name" => "name2",
              "components" =>
                [
                  { "type" => "HEADER", "format" => "TEXT", "text" => "Our {{1}} is on!",
                    "example" => { "header_text" => ["Summer Sale"] } },
                  { "type" => "BODY",
                    "text" => "Shop now through {{1}} and use code {{2}} to get {{3}} off of all merchandise.",
                    "example" => { "body_text" => [["the end of August", "25OFF", "25%"]] } },
                  { "type" => "FOOTER", "text" => "Use the buttons below to manage your marketing subscriptions" },
                  { "type" => "BUTTONS",
                    "buttons" => [{ "type" => "QUICK_REPLY", "text" => "Unsubscribe from Promos" },
                                  { "type" => "QUICK_REPLY", "text" => "Unsubscribe from All" }] }
                ],
              "language" => "en_US",
              "status" => "REJECTED",
              "category" => "MARKETING",
              "id" => "243213188351928"
            }
          ]
        }
      end
    end
  end
end

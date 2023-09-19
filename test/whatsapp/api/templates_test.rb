# typed: true
# frozen_string_literal: true

require "test_helper"
require 'api/templates'

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

      def test_create_a_template_with_valid_params_and_no_components
        mock_response

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

        response = @templates_api.create(
          business_id: 123_456,
          name: "seasonal_promotion",
          language: "en_US",
          category: "MARKETING",
          components_json: []
        )

        assert_templates_mock_response(valid_template_response, response)
        assert_predicate(response, :ok?)
      end

      def test_create_a_template_with_valid_params
        mock_response
        components_json = components_json_example

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

        response = @templates_api.create(
          business_id: 123_456,
          name: "seasonal_promotion",
          language: "en_US",
          category: "MARKETING",
          components_json: components_json
        )

        assert_templates_mock_response(valid_template_response, response)
        assert_predicate(response, :ok?)
      end

      def test_create_error_response
        @templates_api.expects(:send_request).returns(invalid_error_response)

        response = @templates_api.create(
          business_id: 123_456,
          name: "seasonal_promotion",
          language: "en_US",
          category: "MARKETING",
          components_json: []
        )

        assert_error_response(invalid_error_response, response, Responses::GenericErrorResponse)
        refute_predicate(response, :ok?)
      end

      ##### GET Templates
      def test_templates_with_valid_output
        business_id = 1234
        @templates_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "#{business_id}/message_templates",
          params: { "limit" => 100 },
          headers: { "Content-Type" => "application/json" }
        ).returns(mocked_templates_index_response)

        response = @templates_api.templates(business_id: business_id, limit: 100)

        assert_ok_response(response)

        templates_data_response = response.data.templates
        assert_equal(mocked_templates_index_response["data"].count, templates_data_response.size)

        mocked_templates_index_response["data"].zip(templates_data_response).each do |expected_template_hash, template|
          assert_equal(expected_template_hash["name"], template.name)
          assert_equal(expected_template_hash["status"], template.status.serialize)
          assert_equal(expected_template_hash["category"], template.category.serialize)
          assert_equal(expected_template_hash["language"], template.language)
          assert_equal(expected_template_hash["id"], template.id)
          assert_equal(expected_template_hash["components"], template.components) # TODO: parse component as object
        end
      end

      def test_templates_with_invalid_output
        business_id = 1234
        @templates_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "#{business_id}/message_templates",
          params: { "limit" => 100 },
          headers: { "Content-Type" => "application/json" }
        ).returns(generic_error_response)

        response = @templates_api.templates(business_id: business_id, limit: 100)

        assert_error_response(generic_error_response, response, Responses::GenericErrorResponse)
      end

      ##### GET Message Template 
      ################## TODO ##################
      def test_template_with_valid_output
        # TODO
      end

      def test_template_with_invalid_output
        # TODO
      end
      ################## TODO ##################


      ##### Update Message Template
      def test_update_template_with_valid_input
        message_template_id = 34564
        components_json = components_json_example

        @templates_api.expects(:send_request).with(
          http_method: "post",
          endpoint: "#{message_template_id}/message_templates",
          params: { components: components_json },
          headers: { "Content-Type" => "application/json" }
        ).returns({ "success" => true })
        
        response = @templates_api.update(message_template_id:,  components_json: components_json_example)
        assert_predicate(response, :ok?)
      end
      
      def test_update_template_returns_error
        message_template_id = 34564
        components_json = components_json_example

        @templates_api.expects(:send_request).with(
          http_method: "post",
          endpoint: "#{message_template_id}/message_templates",
          params: { components: components_json },
          headers: { "Content-Type" => "application/json" }
        ).returns(invalid_error_response)

        response = @templates_api.update(message_template_id:,  components_json: components_json_example)
        assert_error_response(invalid_error_response, response, Responses::GenericErrorResponse)
        refute_predicate(response, :ok?)
      end

      ##### Delete Message Template
      def test_delete_template_by_name
        business_id = 123_456
        name = "seasonal_promotion"

        @templates_api.expects(:send_request).with(
          http_method: "delete",
          endpoint: "#{business_id}/message_templates",
          params: { name: name },
          headers: { "Content-Type" => "application/json" }
        ).returns({ "success" => true })

        response = @templates_api.delete_template(business_id: business_id, name: name)

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
          },
          headers: { "Content-Type" => "application/json" }
        ).returns({ "success" => true })

        response = @templates_api.delete_template(business_id: business_id, name: name, hsm_id: hsm_id)

        validate_sucess_data_response(response)
      end

      def test_delete_template_with_error_response
        business_id = 123_456
        name = "seasonal_promotion"

        @templates_api.expects(:send_request).with(
          http_method: "delete",
          endpoint: "#{business_id}/message_templates",
          params: { name: name },
          headers: { "Content-Type" => "application/json" }
        ).returns(generic_error_response)

        response = @templates_api.delete_template(business_id: business_id, name: name)
        assert_error_response(generic_error_response, response, Responses::GenericErrorResponse)
      end

      private

      def mocked_templates_index_response # no data?
        { "data" =>
      [
        { "name" => "seasonal_promotion",
         "components" =>
         [{ "type" => "BODY",
            "text" =>
            "Thank you for your order, {{1}}! Your confirmation number is {{2}}. If you have any questions, " \
            "please use the buttons below to contact support. Thank you for being a customer!",
            "example" => { "body_text" => [%w[Pablo 860198-230332]] } }],
         "language" => "en_US",
         "status" => "PENDING",
         "category" => "MARKETING",
         "id" => "637943821653497" },
       { "name" => "sai_marketing",
         "components" =>
         [{ "type" => "HEADER", "format" => "TEXT", "text" => "Hey. I am a header" },
          { "type" => "BODY", "text" => "I am the body." },
          { "type" => "FOOTER", "text" => "Footer." },
          { "type" => "BUTTONS",
            "buttons" => [{ "type" => "URL", "text" => "24", "url" => "http://www.ignaciochiazzo.com/" }] }],
         "language" => "en_US",
         "status" => "APPROVED",
         "category" => "MARKETING",
         "id" => "543793501275350" },
       { "name" => "seasonal_promotionasda_4",
         "components" =>
         [
           {
             "type" => "HEADER", "format" => "TEXT",
             "text" => "Our {{1}} is on!", "example" => { "header_text" => ["Summer Sale"] }
           },
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
         "id" => "1624560287967996" },
       { "name" => "name2",
         "components" =>
         [
           {
             "type" => "HEADER", "format" => "TEXT",
             "text" => "Our {{1}} is on!", "example" => { "header_text" => ["Summer Sale"] }
           },
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
         "id" => "243213188351928" }
        ],
        "paging" => { "cursors" => { "before" => "MAZDZD", "after" => "OTkZD" } } }
      end

      def invalid_error_response
        {
          "error" => {
            "message" => "Invalid parameter",
            "type" => "OAuthException",
            "code" => 100,
            "error_subcode" => 2_388_155,
            "is_transient" => false,
            "error_user_title" => "Template name is already used as a sample template",
            "error_user_msg" =>
              "This template is named after a sample template created by default. Please use a different name.",
            "fbtrace_id" => "ANU9GosUe_PeleMar"
          }
        }
      end

      def validate_sucess_data_response(response)
        assert_ok_response(response)
        assert_equal(Responses::SuccessResponse, response.data.class)
        assert_predicate(response.data, :success?)
      end

      def mock_response
        @templates_api.stubs(:send_request).returns(valid_template_response)
        valid_template_response
      end

      def assert_templates_mock_response(expected_response, response)
        assert_ok_response(response)
        assert_equal(Response, response.class)
        assert_equal(expected_response["id"], response.raw_response["id"])
        assert_equal(expected_response["status"], response.raw_response["status"])
        assert_equal(expected_response["category"], response.raw_response["category"])
      end

      # TODO: Move this to a generic helper
      def assert_ok_response(response)
        assert_equal(Response, response.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
      end

      def components_json_example
        [{
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
      end

      def valid_template_response
        @valid_template_response ||= {
          "id" => "123456",
          "status" => "PENDING",
          "category" => "MARKETING"
        }
      end
    end
  end
end

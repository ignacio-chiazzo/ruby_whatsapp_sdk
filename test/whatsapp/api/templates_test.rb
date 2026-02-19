# typed: true
# frozen_string_literal: true

require "test_helper"
require 'api/templates'
require 'api/client'
require 'api/messages'

module WhatsappSdk
  module Api
    class TemplatesTest < Minitest::Test
      include(ErrorsHelper)

      def setup
        client = Client.new(ENV.fetch('WHATSAPP_ACCESS_TOKEN', nil))
        @messages_api = Messages.new(client)
        @templates_api = Templates.new(client)
      end

      ##### GET
      def test_get_a_template_by_id
        VCR.use_cassette('templates/get_a_template_by_id') do
          template = @templates_api.get(template_id: '1297883712183052')

          assert_equal(Resource::Template, template.class)
          assert_equal('1297883712183052', template.id)
          assert_equal('MARKETING', template.category)
        end
      end

      def test_get_a_template_when_not_exists_an_error_is_returned
        VCR.use_cassette('templates/get_a_template_when_not_exists_an_error_is_returned') do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @templates_api.get(template_id: '1297883712183060')
          end

          assert_equal(400, http_error.http_status)
        end
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

      def test_create_a_template_raises_an_error_when_the_parameter_format_is_invalid
        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidParameterFormatError) do
          @templates_api.create(
            business_id: 123_456,
            name: "seasonal_promotion",
            language: "en_US",
            category: "MARKETING",
            parameter_format: "invalid_parameter_format"
          )
        end

        assert_equal("Invalid Parameter Format. The possible values are: named and positional.", error.message)
      end

      def test_create_a_template_with_valid_params_and_components
        VCR.use_cassette('templates/create_a_template_with_valid_params_and_components') do
          new_template = @templates_api.create(
            business_id: 114_503_234_599_312, name: "seasonal_promotion", language: "nl", category: "MARKETING",
            components_json: basic_components_json, allow_category_change: true
          )

          assert_equal(Resource::Template, new_template.class)
          assert_equal("MARKETING", new_template.category)
          assert_equal("PENDING", new_template.status)
          assert(new_template.id)
        end
      end

      def test_create_a_template_with_named_parameters
        VCR.use_cassette('templates/create_a_template_with_named_parameters') do
          new_template = @templates_api.create(
            business_id: 114_503_234_599_312, name: "seasonal_promotion", language: "en", category: "MARKETING",
            components_json: basic_named_components_json, parameter_format: "named"
          )

          assert_equal(Resource::Template, new_template.class)
          assert_equal("MARKETING", new_template.category)
          assert_equal("PENDING", new_template.status)
          assert(new_template.id)
        end
      end

      ##### GET Templates
      def test_get_templates
        VCR.use_cassette('templates/get_templates') do
          templates_pagination = @templates_api.list(business_id: 114_503_234_599_312)

          assert_equal(25, templates_pagination.records.size)
          assert(templates_pagination.before)
          assert(templates_pagination.after)

          first_template = templates_pagination.records.first
          assert_equal(Resource::Template, first_template.class)
          assert_equal("711633970112948", first_template.id)
          assert_equal("hello_world", first_template.name)
          assert_equal("MARKETING", first_template.category)
          assert_equal("en_US", first_template.language)
          assert_equal("APPROVED", first_template.status)
          assert_equal(
            [{ "type" => "HEADER", "format" => "TEXT", "text" => "Hello World" },
             { "type" => "BODY",
               "text" =>
               "Welcome and congratulations!! This message demonstrates your ability to send a message " \
               "notification from WhatsApp Business Platform’s Cloud API. Thank you for taking the time " \
               "to test with us." },
             { "type" => "FOOTER", "text" => "WhatsApp Business API Team" }],
            first_template.components_json
          )
        end
      end

      def test_get_templates_when_an_error_is_returned
        VCR.use_cassette('templates/get_templates_when_an_error_is_returned') do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @templates_api.list(business_id: 123_456)
          end

          assert_equal(400, http_error.http_status)
          assert_unsupported_request_error_v2("get", "123456", "AhvemSTIjTs-WJikZKj0mLu", http_error.error_info)
        end
      end

      def test_get_templates_when_empty_response_is_returned
        VCR.use_cassette('templates/get_templates_when_empty_response_is_returned') do
          templates = @templates_api.list(business_id: 114_503_234_599_312)

          assert_equal(0, templates.records.size)
          assert_nil(templates.before)
          assert_nil(templates.after)
        end
      end

      ##### GET Message Template namespace
      def test_get_template_namespace
        VCR.use_cassette('templates/get_template_namespace') do
          message_template_namespace = @templates_api.get_message_template_namespace(business_id: 114_503_234_599_312)
          assert_equal(Resource::MessageTemplateNamespace, message_template_namespace.class)
          assert_equal("114503234599312", message_template_namespace.id)
          assert_equal("ffac72fb_6591_4cb3_bb24_0c33a6633999", message_template_namespace.message_template_namespace)
        end
      end

      def test_get_template_namespace_when_an_error_is_returned
        VCR.use_cassette('templates/get_template_namespace_when_an_error_is_returned') do
          fake_business_id = 123_456
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @templates_api.get_message_template_namespace(business_id: fake_business_id)
          end

          assert_equal(400, http_error.http_status)
          assert_unsupported_request_error_v2("get", "123456", "A8nD588C9Qpiid9YWpnwzYB", http_error.error_info)
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
          assert(
            @templates_api.update(
              template_id: "1713674996085293", components_json: basic_components_json
            )
          )
        end
      end

      ##### Delete Message Template
      def test_delete_template_by_name
        VCR.use_cassette('templates/delete_template_by_name') do
          assert(
            @templates_api.delete(
              business_id: 114_503_234_599_312, name: "seasonal_promotion"
            )
          )
        end
      end

      def test_delete_template_by_id
        VCR.use_cassette('templates/delete_template_by_id') do
          assert(
            @templates_api.delete(
              business_id: 114_503_234_599_312, name: "seasonal_promotion", hsm_id: 1_075_472_707_447_727
            )
          )
        end
      end

      def test_delete_template_with_error_response
        VCR.use_cassette('templates/delete_template_with_error_response') do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @templates_api.delete(business_id: 114_503_234_599_312, name: "fake name")
          end

          assert_error_info(
            {
              code: 100,
              error_subcode: 2_593_002,
              type: "OAuthException",
              message: "Invalid parameter",
              fbtrace_id: "Ax5tIkALJCP4l5S8jbPvW2n"
            },
            http_error.error_info
          )
        end
      end

      ##### Template Analytics
      def test_template_analytics_with_valid_params
        VCR.use_cassette('templates/template_analytics_with_valid_params') do
          start_time = Time.utc(2026, 1, 1).to_i
          end_time = Time.utc(2026, 1, 1, 23, 59, 59).to_i

          analytics_pagination = @templates_api.template_analytics(
            business_id: 114_503_234_599_312,
            start_timestamp: start_time,
            end_timestamp: end_time,
            template_ids: ['25979270448374156']
          )

          assert_equal(Api::Responses::PaginationRecords, analytics_pagination.class)
          assert(analytics_pagination.records.is_a?(Array))

          first_analytic = analytics_pagination.records.first
          assert_equal(Resource::TemplateAnalytic, first_analytic.class) if first_analytic
        end
      end

      def test_template_analytics_with_metric_types
        VCR.use_cassette('templates/template_analytics_with_metric_types') do
          start_time = Time.utc(2026, 1, 1).to_i
          end_time = Time.utc(2026, 1, 1, 23, 59, 59).to_i

          analytics_pagination = @templates_api.template_analytics(
            business_id: 114_503_234_599_312,
            start_timestamp: start_time.to_i,
            end_timestamp: end_time.to_i,
            template_ids: ['25979270448374156'],
            metric_types: [
              WhatsappSdk::Resource::TemplateAnalytic::MetricType::SENT,
              WhatsappSdk::Resource::TemplateAnalytic::MetricType::DELIVERED,
              WhatsappSdk::Resource::TemplateAnalytic::MetricType::READ
            ]
          )

          assert_equal(Api::Responses::PaginationRecords, analytics_pagination.class)
          assert(analytics_pagination.records.is_a?(Array))
          refute_empty(analytics_pagination.records)
          assert(analytics_pagination.records.first.data_points.all? do |data_point|
            data_point['sent'] >= 0 && data_point['delivered'] >= 0 && data_point['read'] >= 0
          end)
        end
      end

      def test_template_analytics_with_multiple_template_ids
        VCR.use_cassette('templates/template_analytics_with_multiple_template_ids') do
          start_time = Time.utc(2026, 1, 1).to_i
          end_time = Time.utc(2026, 1, 1, 23, 59, 59).to_i

          analytics_pagination = @templates_api.template_analytics(
            business_id: 114_503_234_599_312,
            start_timestamp: start_time,
            end_timestamp: end_time,
            template_ids: %w[25979270448374156 942922711732342]
          )

          assert_equal(Api::Responses::PaginationRecords, analytics_pagination.class)
          assert(analytics_pagination.records.is_a?(Array))
        end
      end

      def test_template_analytics_with_custom_granularity
        VCR.use_cassette('templates/template_analytics_with_custom_granularity') do
          start_time = Time.utc(2026, 1, 1).to_i
          end_time = Time.utc(2026, 1, 1, 23, 59, 59).to_i

          analytics_pagination = @templates_api.template_analytics(
            business_id: 114_503_234_599_312,
            start_timestamp: start_time,
            end_timestamp: end_time,
            template_ids: ['25979270448374156'],
            granularity: WhatsappSdk::Resource::TemplateAnalytic::Granularity::DAILY
          )

          assert_equal(Api::Responses::PaginationRecords, analytics_pagination.class)
          assert(analytics_pagination.records.is_a?(Array))
        end
      end

      def test_template_analytics_raises_error_for_invalid_granularity
        start_time = Time.utc(2026, 1, 1).to_i
        end_time = Time.utc(2026, 1, 1, 23, 59, 59).to_i

        error = assert_raises(ArgumentError) do
          @templates_api.template_analytics(
            business_id: 114_503_234_599_312,
            start_timestamp: start_time,
            end_timestamp: end_time,
            template_ids: ['25979270448374156'],
            granularity: 'HOURLY'
          )
        end

        assert_equal("Invalid granularity. The only supported granularity is DAILY.", error.message)
      end

      def test_template_analytics_raises_error_for_invalid_metric_type
        start_time = Time.utc(2026, 1, 1).to_i
        end_time = Time.utc(2026, 1, 1, 23, 59, 59).to_i

        error = assert_raises(ArgumentError) do
          @templates_api.template_analytics(
            business_id: 114_503_234_599_312,
            start_timestamp: start_time,
            end_timestamp: end_time,
            template_ids: ['25979270448374156'],
            metric_types: ['INVALID_METRIC']
          )
        end

        valid_types = WhatsappSdk::Resource::TemplateAnalytic::MetricType::METRIC_TYPES.join(', ')
        assert_equal("Invalid metric type. Valid types are: #{valid_types}.", error.message)
      end

      def test_template_analytics_with_empty_metric_types
        VCR.use_cassette('templates/template_analytics_with_empty_metric_types') do
          start_time = Time.utc(2026, 1, 1).to_i
          end_time = Time.utc(2026, 1, 1, 23, 59, 59).to_i

          analytics_pagination = @templates_api.template_analytics(
            business_id: 114_503_234_599_312,
            start_timestamp: start_time,
            end_timestamp: end_time,
            template_ids: ['25979270448374156'],
            metric_types: []
          )

          assert_equal(Api::Responses::PaginationRecords, analytics_pagination.class)
          assert(analytics_pagination.records.is_a?(Array))
        end
      end

      def test_template_analytics_with_error_response
        VCR.use_cassette('templates/template_analytics_with_error_response') do
          start_time = Time.utc(2026, 1, 1).to_i
          end_time = Time.utc(2026, 1, 1, 23, 59, 59).to_i

          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @templates_api.template_analytics(
              business_id: 123_456,
              start_timestamp: start_time,
              end_timestamp: end_time,
              template_ids: ['fake_id']
            )
          end

          assert_equal(400, http_error.http_status)
        end
      end

      def test_template_analytics_with_all_metric_types
        VCR.use_cassette('templates/template_analytics_with_all_metric_types') do
          start_time = Time.utc(2026, 1, 1).to_i
          end_time = Time.utc(2026, 1, 1, 23, 59, 59).to_i

          analytics_pagination = @templates_api.template_analytics(
            business_id: 114_503_234_599_312,
            start_timestamp: start_time,
            end_timestamp: end_time,
            template_ids: ['25979270448374156'],
            metric_types: [
              WhatsappSdk::Resource::TemplateAnalytic::MetricType::COST,
              WhatsappSdk::Resource::TemplateAnalytic::MetricType::CLICKED,
              WhatsappSdk::Resource::TemplateAnalytic::MetricType::DELIVERED,
              WhatsappSdk::Resource::TemplateAnalytic::MetricType::READ,
              WhatsappSdk::Resource::TemplateAnalytic::MetricType::SENT
            ]
          )

          assert_equal(Api::Responses::PaginationRecords, analytics_pagination.class)
          assert(analytics_pagination.records.is_a?(Array))
        end
      end

      def test_template_analytics_with_after_cursor
        VCR.use_cassette('templates/template_analytics_with_after_cursor') do
          start_time = Time.utc(2026, 1, 1).to_i
          end_time = Time.utc(2026, 1, 1, 23, 59, 59).to_i

          analytics_pagination = @templates_api.template_analytics(
            business_id: 114_503_234_599_312,
            start_timestamp: start_time,
            end_timestamp: end_time,
            template_ids: ['25979270448374156'],
            after: 'MjQZD'
          )

          assert_equal(Api::Responses::PaginationRecords, analytics_pagination.class)
          assert(analytics_pagination.records.is_a?(Array))
          refute_empty(analytics_pagination.records)
        end
      end

      private

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

      def basic_named_components_json
        [
          {
            type: "BODY",
            text: "Thank you for your order, {{name}}! Your confirmation number is {{order_number}}. " \
                  "If you have any questions, please use the buttons below to contact support. " \
                  "Thank you for being a customer!",
            example: { body_text_named_params: [
              {
                param_name: 'name',
                example: 'Ignacio'
              },
              {
                param_name: 'order_number',
                example: '860198-230332'
              }
            ] }
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

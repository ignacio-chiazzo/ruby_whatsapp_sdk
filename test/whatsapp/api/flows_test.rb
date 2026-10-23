# frozen_string_literal: true

require 'test_helper'
require 'whatsapp_sdk'
require 'tempfile'

module WhatsappSdk
  module Api
    class FlowsTest < Minitest::Test
      def setup
        @client = Client.new('flow-token', 'v25.0')
      end

      def test_lists_flows_with_fields_limit_and_cursor
        record = { 'id' => 'flow-id', 'name' => 'Survey', 'status' => 'DRAFT', 'validation_errors' => [] }
        request = stub_request(:get, 'https://graph.facebook.com/v25.0/waba-id/flows').with(
          query: { fields: 'id,name,status', limit: '20', after: 'cursor+/=' },
          headers: { 'Authorization' => 'Bearer flow-token' }
        ).to_return(body: { data: [record], paging: { cursors: { before: 'previous', after: 'next' } } }.to_json)

        VCR.turned_off do
          result = @client.flows.list(business_id: 'waba-id', fields: %w[id name status], limit: 20, after: 'cursor+/=')
          assert_equal([record], result.records)
          assert_equal('previous', result.before)
          assert_equal('next', result.after)
        end
        assert_requested(request, times: 1)
      end

      def test_empty_list_without_paging
        stub_request(:get, 'https://graph.facebook.com/v25.0/waba-id/flows?limit=100').to_return(body: '{"data":[]}')
        VCR.turned_off do
          result = @client.flows.list(business_id: 'waba-id')
          assert_empty(result.records)
          assert_nil(result.before)
          assert_nil(result.after)
        end
      end

      def test_get_preserves_requested_fields_and_client_configuration
        record = { 'id' => 'flow-id', 'status' => 'DRAFT', 'endpoint_uri' => 'https://example.com/flow' }
        stub_request(:get, 'https://graph.facebook.com/v24.0/flow-id').with(
          query: { fields: 'id,status,endpoint_uri' }, headers: { 'Authorization' => 'Bearer other-token' }
        ).to_return(body: record.to_json)
        VCR.turned_off do
          result = Client.new('other-token', 'v24.0').flows.get(flow_id: 'flow-id', fields: %w[id status endpoint_uri])
          assert_equal(record, result)
        end
      end

      def test_create_sends_json_and_keeps_validation_errors_without_publishing
        result = { 'id' => 'flow-id', 'success' => true,
                   'validation_errors' => [{ 'error' => 'INVALID_PROPERTY_VALUE' }] }
        request = stub_request(:post, 'https://graph.facebook.com/v25.0/waba-id/flows').with(
          headers: { 'Content-Type' => 'application/json', 'Authorization' => 'Bearer flow-token' },
          body: { name: 'Pesquisa São Paulo', categories: ['SURVEY'], endpoint_uri: 'https://example.com/flow' }.to_json
        ).to_return(body: result.to_json)
        VCR.turned_off do
          assert_equal(result, @client.flows.create(business_id: 'waba-id', name: 'Pesquisa São Paulo',
                                                    categories: ['SURVEY'], endpoint_uri: 'https://example.com/flow'))
        end
        assert_requested(request, times: 1)
        assert_not_requested(:post, 'https://graph.facebook.com/v25.0/flow-id/publish')
      end

      def test_create_omits_optional_endpoint
        stub_request(:post, 'https://graph.facebook.com/v25.0/waba-id/flows').with(
          body: { name: 'Survey', categories: ['SURVEY'] }.to_json
        ).to_return(body: '{"id":"flow-id"}')
        VCR.turned_off do
          assert_equal('flow-id',
                       @client.flows.create(business_id: 'waba-id', name: 'Survey', categories: ['SURVEY'])['id'])
        end
      end

      def test_upload_json_preserves_utf8_and_returns_validation_errors
        json = '{"version":"5.0","screens":[],"title":"Olá 🌎"}'
        result = { 'success' => true, 'validation_errors' => [{ 'error' => 'INVALID_PROPERTY_VALUE' }] }
        request = stub_request(:post, 'https://graph.facebook.com/v25.0/flow-id/assets').with do |req|
          req.headers['Content-Type'].start_with?('multipart/form-data; boundary=') &&
            req.headers['Authorization'] == 'Bearer flow-token' &&
            req.body.include?(json.b) && req.body.include?('filename="flow.json"') &&
            req.body.include?("name=\"asset_type\"\r\n\r\nFLOW_JSON") &&
            req.body.include?("name=\"name\"\r\n\r\nflow.json")
        end.to_return(body: result.to_json)
        Tempfile.create(['survey', '.json']) do |file|
          file.write(json)
          file.flush
          VCR.turned_off { assert_equal(result, @client.flows.upload_json(flow_id: 'flow-id', file_path: file.path)) }
        end
        assert_requested(request, times: 1)
      end

      def test_upload_rejects_missing_files_and_directories_before_sending
        ['missing-flow.json', 'test/fixtures/assets'].each do |path|
          assert_raises(Medias::FileNotFoundError) { @client.flows.upload_json(flow_id: 'flow-id', file_path: path) }
        end
        assert_not_requested(:post, 'https://graph.facebook.com/v25.0/flow-id/assets')
      end

      def test_publishes_only_when_explicitly_requested
        request = stub_request(:post,
                               'https://graph.facebook.com/v25.0/flow-id/publish').to_return(body: '{"success":true}')
        VCR.turned_off { assert_equal({ 'success' => true }, @client.flows.publish(flow_id: 'flow-id')) }
        assert_requested(request, times: 1)
      end

      def test_preserves_graph_errors_without_retrying_publish
        request = stub_request(:post, 'https://graph.facebook.com/v25.0/flow-id/publish').to_return(
          status: 400, body: { error: { message: 'Invalid Flow', code: 139_002, error_subcode: 4_233_046 } }.to_json
        )
        VCR.turned_off do
          error = assert_raises(Responses::HttpResponseError) { @client.flows.publish(flow_id: 'flow-id') }
          assert_equal(4_233_046, error.body.dig('error', 'error_subcode'))
        end
        assert_requested(request, times: 1)
      end
    end
  end
end

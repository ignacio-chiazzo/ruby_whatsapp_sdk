# frozen_string_literal: true

require 'test_helper'
require 'whatsapp_sdk'

module WhatsappSdk
  module Api
    class FlowAssetsTest < Minitest::Test
      def setup
        @client = Client.new('flow-token', 'v24.0')
      end

      def test_lists_assets_with_cursors_without_downloading_or_exposing_credentials_to_the_cdn
        asset = { 'name' => 'flow.json', 'asset_type' => 'FLOW_JSON', 'download_url' => 'https://cdn.example.com/flow.json' }
        request = stub_request(:get, 'https://graph.facebook.com/v24.0/flow/assets')
                  .with(query: { limit: '20', after: 'next+/=' }, headers: { 'Authorization' => 'Bearer flow-token' })
                  .to_return(body: { data: [asset], paging: { cursors: { before: 'before', after: 'after' } } }.to_json)

        page = @client.flows.assets(flow_id: 'flow', limit: 20, after: 'next+/=')

        assert_equal([asset], page.records)
        assert_equal('before', page.before)
        assert_equal('after', page.after)
        assert_requested(request, times: 1)
        assert_not_requested(:get, 'https://cdn.example.com/flow.json')
      end

      def test_preserves_graph_errors_for_assets
        body = { error: { message: 'Permission denied', code: 200, type: 'OAuthException' } }.to_json
        assets = stub_request(:get, 'https://graph.facebook.com/v24.0/flow/assets?limit=100')
                 .to_return(status: 403, body: body)

        error = assert_raises(Responses::HttpResponseError) { @client.flows.assets(flow_id: 'flow') }
        assert_equal(403, error.http_status)
        assert_requested(assets, times: 1)
      end

      def test_empty_assets_without_paging
        stub_request(:get, 'https://graph.facebook.com/v24.0/flow/assets?limit=100').to_return(body: '{"data":[]}')

        page = @client.flows.assets(flow_id: 'flow')

        assert_empty(page.records)
        assert_nil(page.before)
        assert_nil(page.after)
      end
    end
  end
end

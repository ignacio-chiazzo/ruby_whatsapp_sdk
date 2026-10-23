# frozen_string_literal: true

require 'test_helper'
require 'whatsapp_sdk'

module WhatsappSdk
  module Api
    class MarketingMessagesTest < Minitest::Test
      def test_raw_marketing_keeps_metadata_and_non_json_errors
        body = { contacts: [{ user_id: "BR.123" }],
                 messages: [{ id: "wamid", message_status: "accepted" }], extra: true }.to_json
        request = stub_request(:post, 'https://graph.facebook.com/v25.0/sender/marketing_messages')
                  .to_return(status: 202, body: body, headers: { 'Retry-After' => '30' })
                  .then.to_return(status: 429, body: '<html>Rate limited</html>')

        VCR.turned_off do
          response = @messages.send_marketing_template(sender_id: 'sender', recipient: 'BR.123', name: 'offer',
                                                       language: 'pt_BR', components_json: [], raw_response: true)
          assert_equal(202, response.status)
          assert_equal(body, response.body)
          assert_equal('30', response.headers['retry-after'])
          response = @messages.send_marketing_template(sender_id: 'sender', recipient: 'BR.123', name: 'offer',
                                                       language: 'pt_BR', components_json: [], raw_response: true)
          assert_equal(429, response.status)
          assert_equal('<html>Rate limited</html>', response.body)
        end
        assert_requested(request, times: 2)
      end

      def setup
        @messages = Client.new('marketing-token', 'v25.0').messages
      end

      def test_sends_template_to_marketing_endpoint_and_preserves_pacing_status
        request = stub_request(:post, 'https://graph.facebook.com/v25.0/sender/marketing_messages').with(
          headers: { 'Authorization' => 'Bearer marketing-token', 'Content-Type' => 'application/json' },
          body: { messaging_product: 'whatsapp', recipient_type: 'individual', to: '5511999999999', type: 'template',
                  template: { name: 'offer', language: { code: 'pt_BR' }, components: [] },
                  product_policy: 'STRICT' }
        ).to_return(body: { messages: [{ id: 'wamid.marketing',
                                         message_status: 'held_for_quality_assessment' }] }.to_json)
        VCR.turned_off do
          response = @messages.send_marketing_template(sender_id: 'sender', recipient_number: '5511999999999',
                                                       name: 'offer', language: 'pt_BR', components_json: [],
                                                       product_policy: 'STRICT')
          assert_equal('wamid.marketing', response.messages.first.id)
          assert_equal('held_for_quality_assessment', response.messages.first.message_status)
        end
        assert_requested(request, times: 1)
        assert_not_requested(:post, 'https://graph.facebook.com/v25.0/sender/messages')
      end

      def test_bsuid_with_component_objects_and_optional_fallback_policy
        component = Resource::Component.new(type: 'body',
                                            parameters: [Resource::ParameterObject.new(
                                              type: 'text', text: 'Ana'
                                            )])
        stub_request(:post, 'https://graph.facebook.com/v25.0/sender/marketing_messages').with(
          body: { messaging_product: 'whatsapp', recipient_type: 'individual', recipient: 'BR.123', type: 'template',
                  template: { name: 'offer', language: { code: 'pt_BR' },
                              components: [{ type: 'body', parameters: [{ type: 'text', text: 'Ana' }] }] },
                  product_policy: 'CLOUD_API_FALLBACK' }
        ).to_return(body: { contacts: [{ input: 'BR.123', user_id: 'BR.123' }],
                            messages: [{ id: 'wamid.bsuid' }] }.to_json)
        VCR.turned_off do
          response = @messages.send_marketing_template(sender_id: 'sender', recipient: 'BR.123', name: 'offer',
                                                       language: 'pt_BR', components: [component],
                                                       product_policy: 'CLOUD_API_FALLBACK')
          assert_equal('BR.123', response.contacts.first.user_id)
          assert_nil(response.contacts.first.wa_id)
          assert_nil(response.messages.first.message_status)
        end
      end

      def test_phone_takes_precedence_and_default_policy_is_omitted
        stub_request(:post, 'https://graph.facebook.com/v24.0/sender/marketing_messages').with(
          headers: { 'Authorization' => 'Bearer other-token' },
          body: { messaging_product: 'whatsapp', recipient_type: 'individual', to: '5511999999999', type: 'template',
                  template: { name: 'offer', language: { code: 'pt_BR' }, components: [] } }
        ).to_return(body: '{"messages":[{"id":"wamid.phone"}]}')
        VCR.turned_off do
          result = Client.new('other-token', 'v24.0').messages.send_marketing_template(
            sender_id: 'sender', recipient_number: '5511999999999', recipient: 'BR.123', name: 'offer',
            language: 'pt_BR', components_json: []
          )
          assert_equal('wamid.phone', result.messages.first.id)
        end
      end

      def test_rejects_missing_or_blank_destinations
        [{}, { recipient: ' ' }, { recipient_number: '', recipient: 'BR.123' }].each do |destination|
          assert_raises(Resource::Errors::MissingArgumentError) do
            @messages.send_marketing_template(sender_id: 'sender', name: 'offer', language: 'pt_BR',
                                              components_json: [], **destination)
          end
        end
        assert_not_requested(:post, 'https://graph.facebook.com/v25.0/sender/marketing_messages')
      end

      def test_rejects_missing_components_both_components_and_missing_language
        assert_raises(Resource::Errors::MissingArgumentError) do
          @messages.send_marketing_template(sender_id: 'sender', recipient: 'BR.123', name: 'offer', language: 'pt_BR')
        end
        assert_raises(ArgumentError) do
          @messages.send_marketing_template(sender_id: 'sender', recipient: 'BR.123', name: 'offer', language: 'pt_BR',
                                            components: [], components_json: [])
        end
        error = assert_raises(Resource::Errors::MissingArgumentError) do
          @messages.send_marketing_template(sender_id: 'sender', recipient: 'BR.123', name: 'offer', language: nil,
                                            components_json: [])
        end
        assert_equal('language is required', error.message)
        assert_not_requested(:post, 'https://graph.facebook.com/v25.0/sender/marketing_messages')
      end

      def test_send_template_shares_template_validations
        assert_raises(ArgumentError) do
          @messages.send_template(sender_id: 'sender', recipient: 'BR.123', name: 'offer', language: 'pt_BR',
                                  components: [], components_json: [])
        end
        assert_raises(Resource::Errors::MissingArgumentError) do
          @messages.send_template(sender_id: 'sender', recipient: 'BR.123', name: 'offer', language: nil,
                                  components_json: [])
        end
        assert_not_requested(:post, 'https://graph.facebook.com/v25.0/sender/messages')
      end

      def test_normalizes_product_policy_and_sends_message_activity_sharing
        request = stub_request(:post, 'https://graph.facebook.com/v25.0/sender/marketing_messages').with(
          body: hash_including(product_policy: 'STRICT', message_activity_sharing: false)
        ).to_return(body: { messages: [{ id: 'wamid.policy' }] }.to_json)
        VCR.turned_off do
          @messages.send_marketing_template(sender_id: 'sender', recipient: 'BR.123', name: 'offer', language: 'pt_BR',
                                            components_json: [], product_policy: :strict,
                                            message_activity_sharing: false)
        end
        assert_requested(request)
      end

      def test_graph_bsuid_restriction_and_timeout_never_fall_back_or_retry
        endpoint = 'https://graph.facebook.com/v25.0/sender/marketing_messages'
        request = stub_request(:post, endpoint).to_return(
          status: 400, body: { error: { code: 131_062, message: 'BSUID cannot use this template bid_spec' } }.to_json
        )
        VCR.turned_off do
          error = assert_raises(Responses::HttpResponseError) do
            @messages.send_marketing_template(sender_id: 'sender', recipient: 'BR.123', name: 'offer',
                                              language: 'pt_BR', components_json: [])
          end
          assert_equal(131_062, error.body.dig('error', 'code'))
          remove_request_stub(request)
          stub_request(:post, endpoint).to_raise(Net::ReadTimeout)
          assert_raises(Faraday::TimeoutError) do
            @messages.send_marketing_template(sender_id: 'sender', recipient: 'BR.123', name: 'offer',
                                              language: 'pt_BR', components_json: [])
          end
        end
        assert_requested(:post, endpoint, times: 2)
        assert_not_requested(:post, 'https://graph.facebook.com/v25.0/sender/messages')
      end
    end
  end
end

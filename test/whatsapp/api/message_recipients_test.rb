# frozen_string_literal: true

require 'test_helper'
require 'api/client'
require 'api/messages'

module WhatsappSdk
  module Api
    class MessageRecipientsTest < Minitest::Test
      destination_keys = %w[to recipient]
      sends = {
        send_text: { message: 'Hello' },
        send_location: { longitude: 1, latitude: 2, name: 'Office', address: 'Main Street' },
        send_image: { image_id: 'media-id' },
        send_audio: { audio_id: 'media-id' },
        send_video: { video_id: 'media-id' },
        send_document: { document_id: 'media-id' },
        send_sticker: { sticker_id: 'media-id' },
        send_contacts: { contacts_json: [{ name: { formatted_name: 'Alice', first_name: 'Alice' } }] },
        send_interactive_message: { interactive_json: { type: 'button', body: { text: 'Choose' }, action: {} } },
        send_template: { name: 'hello_world', language: 'en_US', components_json: [] },
        send_reaction: { message_id: 'wamid.original', emoji: '👍' }
      }
      destinations = {
        phone: [{ recipient_number: '16505551234' }, { 'to' => '16505551234' }],
        bsuid: [{ recipient: 'US.123abc' }, { 'recipient' => 'US.123abc' }],
        parent_bsuid: [{ recipient: 'US.ENT.123abc' }, { 'recipient' => 'US.ENT.123abc' }],
        both: [{ recipient_number: '16505551234', recipient: 'US.123abc' }, { 'to' => '16505551234' }]
      }
      invalid_destinations = [{}, { recipient: '' }, { recipient: '  ' }, { recipient_number: '' }]

      sends.each do |method, arguments|
        destinations.each do |kind, (destination, expected)|
          define_method("test_#{method}_with_#{kind}") do
            contact = if expected.key?('to')
                        { input: '16505551234', wa_id: '16505551234' }
                      else
                        { input: expected['recipient'], user_id: expected['recipient'] }
                      end
            request = stub_request(:post, 'https://graph.facebook.com/v25.0/123/messages').with do |req|
              payload = JSON.parse(req.body)
              payload.select { |key, _| destination_keys.include?(key) } == expected &&
                payload['messaging_product'] == 'whatsapp' && payload['recipient_type'] == 'individual'
            end.to_return(status: 200, body: {
              messaging_product: 'whatsapp', contacts: [contact], messages: [{ id: 'wamid.sent' }]
            }.to_json)

            VCR.turned_off do
              result = Client.new('token', 'v25.0').messages.public_send(
                method, sender_id: '123', **arguments, **destination
              )
              assert_equal('wamid.sent', result.messages.first.id)
              assert_equal(contact[:input], result.contacts.first.input)
              if expected.key?('to')
                assert_equal('16505551234', result.contacts.first.wa_id)
                assert_nil(result.contacts.first.user_id)
              else
                assert_nil(result.contacts.first.wa_id)
                assert_equal(expected['recipient'], result.contacts.first.user_id)
              end
            end
            assert_requested(request, times: 1)
          end
        end

        invalid_destinations.each_with_index do |destination, index|
          define_method("test_#{method}_rejects_missing_destination_#{index}") do
            assert_raises(Resource::Errors::MissingArgumentError) do
              Client.new('token', 'v25.0').messages.public_send(method, sender_id: '123', **arguments, **destination)
            end
            assert_not_requested(:post, 'https://graph.facebook.com/v25.0/123/messages')
          end
        end
      end
    end
  end
end

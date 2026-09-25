# frozen_string_literal: true

require 'test_helper'
require 'api/client'
require 'api/messages'

module WhatsappSdk
  module Api
    class AudioVoiceTest < Minitest::Test
      voice_options = { default: {}, voice_note: { voice: true }, regular_audio: { voice: false } }
      [
        [{ audio_id: 'media-id' }, { id: 'media-id' }],
        [{ link: 'https://example.com/audio.ogg' }, { link: 'https://example.com/audio.ogg' }]
      ].each do |source, audio|
        voice_options.each do |name, options|
          define_method("test_#{source.keys.first}_#{name}") do
            request = stub_request(:post, 'https://graph.facebook.com/v25.0/123/messages').with(
              headers: { 'Authorization' => 'Bearer test-token', 'Content-Type' => 'application/json' },
              body: {
                messaging_product: 'whatsapp', to: '456', recipient_type: 'individual', type: 'audio',
                audio: audio.merge(voice: options.fetch(:voice, false)), context: { message_id: 'reply-id' }
              }.to_json
            ).to_return(status: 200, body: { messages: [{ id: 'wamid.audio' }] }.to_json)

            VCR.turned_off do
              response = Client.new('test-token', 'v25.0').messages.send_audio(
                sender_id: '123', recipient_number: '456', message_id: 'reply-id', **source, **options
              )
              assert_equal('wamid.audio', response.messages.first.id)
            end
            assert_requested(request, times: 1)
          end
        end
      end
    end
  end
end

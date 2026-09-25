# frozen_string_literal: true

require 'test_helper'
require 'api/client'
require 'api/medias'

module WhatsappSdk
  module Api
    class MediaUploadSessionsTest < Minitest::Test
      def setup
        @media = Client.new('client-token', 'v25.0').media
        @file_path = 'test/fixtures/assets/whatsapp.png'
        @session_id = 'upload:session-id?sig=signature'
      end

      def test_create_session_uses_client_version_and_token
        request = stub_request(:post, 'https://graph.facebook.com/v25.0/app-id/uploads').with(
          headers: { 'Authorization' => 'Bearer client-token', 'Content-Type' => 'application/json' },
          body: { file_name: 'whatsapp.png', file_length: File.size(@file_path), file_type: 'image/png' }.to_json
        ).to_return(status: 200, body: { id: @session_id }.to_json)

        VCR.turned_off do
          result = @media.create_upload_session(app_id: 'app-id', file_path: @file_path, type: 'image/png')
          assert_equal(@session_id, result['id'])
        end
        assert_requested(request, times: 1)
      end

      def test_upload_session_sends_unmodified_binary_and_returns_handle
        request = stub_request(:post, 'https://graph.facebook.com/v25.0/upload:session-id?sig=signature').with(
          headers: {
            'Authorization' => 'Bearer client-token', 'Content-Type' => 'application/octet-stream', 'file_offset' => '0'
          },
          body: File.binread(@file_path)
        ).to_return(status: 200, body: { h: '4::media-handle' }.to_json)

        VCR.turned_off do
          result = @media.upload_file_to_session(session_id: @session_id, file_path: @file_path)
          assert_equal('4::media-handle', result['h'])
        end
        assert_requested(request, times: 1)
      end

      def test_explicit_token_overrides_only_that_request
        override = stub_request(:post, 'https://graph.facebook.com/v25.0/app-id/uploads').with(
          headers: { 'Authorization' => 'Bearer override-token' }
        ).to_return(status: 200, body: { id: @session_id }.to_json)
        configured = stub_request(:post, 'https://graph.facebook.com/v25.0/upload:session-id?sig=signature').with(
          headers: { 'Authorization' => 'Bearer client-token' }
        ).to_return(status: 200, body: { h: '4::handle' }.to_json)

        VCR.turned_off do
          @media.create_upload_session(
            app_id: 'app-id', file_path: @file_path, type: 'image/png', access_token: 'override-token'
          )
          @media.upload_file_to_session(session_id: @session_id, file_path: @file_path)
        end
        assert_requested(override, times: 1)
        assert_requested(configured, times: 1)
      end

      def test_upload_accepts_explicit_token_and_another_api_version
        request = stub_request(:post, 'https://graph.facebook.com/v24.0/upload:session-id?sig=signature').with(
          headers: { 'Authorization' => 'Bearer override-token' }
        ).to_return(status: 200, body: { h: '4::handle' }.to_json)

        VCR.turned_off do
          result = Client.new('client-token', 'v24.0').media.upload_file_to_session(
            session_id: @session_id, file_path: @file_path, access_token: 'override-token'
          )
          assert_equal('4::handle', result['h'])
        end
        assert_requested(request, times: 1)
      end

      def test_missing_files_and_directories_are_rejected_before_requests
        ['missing-file.png', 'test/fixtures/assets'].each do |file_path|
          assert_raises(Medias::FileNotFoundError) do
            @media.create_upload_session(app_id: 'app-id', file_path: file_path, type: 'image/png')
          end
          assert_raises(Medias::FileNotFoundError) do
            @media.upload_file_to_session(session_id: @session_id, file_path: file_path)
          end
        end
        assert_not_requested(:post, %r{\Ahttps://graph\.facebook\.com/})
      end

      def test_create_session_preserves_graph_error
        stub_request(:post, 'https://graph.facebook.com/v25.0/app-id/uploads').to_return(
          status: 400, body: { error: { message: 'Invalid file type', type: 'OAuthException', code: 100 } }.to_json
        )
        VCR.turned_off do
          error = assert_raises(Responses::HttpResponseError) do
            @media.create_upload_session(app_id: 'app-id', file_path: @file_path, type: 'image/png')
          end
          assert_equal(400, error.http_status)
          assert_equal(100, error.body.dig('error', 'code'))
        end
      end

      def test_upload_session_preserves_graph_error
        stub_request(:post, 'https://graph.facebook.com/v25.0/upload:session-id?sig=signature').to_return(
          status: 401, body: { error: { message: 'Invalid token', type: 'OAuthException', code: 190 } }.to_json
        )
        VCR.turned_off do
          error = assert_raises(Responses::HttpResponseError) do
            @media.upload_file_to_session(session_id: @session_id, file_path: @file_path)
          end
          assert_equal(401, error.http_status)
          assert_equal(190, error.body.dig('error', 'code'))
        end
      end
    end
  end
end

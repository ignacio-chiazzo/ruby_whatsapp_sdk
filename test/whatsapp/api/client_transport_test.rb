# frozen_string_literal: true

require 'test_helper'
require 'api/client'
require 'api/api_configuration'
require 'whatsapp_sdk'
require 'stringio'
require 'timeout'

module WhatsappSdk
  module Api
    class ClientTransportTest < Minitest::Test
      # Observe what the SDK passes to the transport without opening real sockets.
      class RecordingAdapter < Faraday::Adapter
        class << self
          attr_accessor :requests, :closed
        end

        def call(env)
          super
          self.class.requests << { adapter: self, url: env.url.to_s, headers: env.request_headers.dup,
                                   body: env.body, options: env.request.dup }
          save_response(env, 200, '{"success":true}', {})
          @app.call(env)
        end

        def close
          self.class.closed << self
        end
      end

      def setup
        RecordingAdapter.requests = []
        RecordingAdapter.closed = []
      end

      def test_reuses_transport_per_client_origin_and_multipart_mode
        first = Client.new('first-token', 'v25.0', adapter: RecordingAdapter)
        second = Client.new('second-token', 'v25.0', adapter: RecordingAdapter)
        first.send_request(endpoint: 'messages')
        first.send_request(endpoint: 'messages')
        first.send_request(endpoint: 'media', multipart: true)
        first.send_request(endpoint: 'messages', full_url: 'https://graph.facebook.com/v24.0/')
        second.send_request(endpoint: 'messages')

        adapters = RecordingAdapter.requests.map { |r| r[:adapter] }
        assert_same(adapters[0], adapters[1])
        assert_same(adapters[0], adapters[3])
        assert_equal(3, adapters.uniq.size)
        assert_equal('https://graph.facebook.com/v24.0/messages', RecordingAdapter.requests[3][:url])
      end

      def test_paging_urls_share_one_connection_and_keep_their_query
        client = Client.new('token', 'v25.0', adapter: RecordingAdapter)
        client.send_request(full_url: 'https://graph.facebook.com/v25.0/123/templates?after=a', http_method: 'get')
        client.send_request(full_url: 'https://graph.facebook.com/v25.0/123/templates?after=b', http_method: 'get',
                            params: { limit: 2 })
        client.send_request(endpoint: './upload:abc', params: 'x')

        first, second, upload = RecordingAdapter.requests
        assert_same(first[:adapter], second[:adapter])
        assert_equal('https://graph.facebook.com/v25.0/123/templates?after=a', first[:url])
        assert_equal('https://graph.facebook.com/v25.0/123/templates?after=b&limit=2', second[:url])
        assert_equal('https://graph.facebook.com/v25.0/upload:abc', upload[:url])
      end

      def test_request_token_overrides_do_not_leak_to_other_requests_or_clients
        first = Client.new('first-token', 'v25.0', adapter: RecordingAdapter)
        second = Client.new('second-token', 'v25.0', adapter: RecordingAdapter)
        first.send_request(endpoint: 'messages', headers: { 'Authorization' => 'Bearer override' })
        second.send_request(endpoint: 'messages')
        first.send_request(endpoint: 'messages')

        assert_equal(['Bearer override', 'Bearer second-token', 'Bearer first-token'],
                     RecordingAdapter.requests.map { |r| r[:headers]['Authorization'] })
      end

      def test_network_path_endpoints_do_not_send_the_token_to_another_host
        client = Client.new('token', 'v25.0', adapter: RecordingAdapter)
        client.send_request(endpoint: '//attacker.example/path')

        assert_equal('https://graph.facebook.com/v25.0///attacker.example/path', RecordingAdapter.requests.first[:url])
      end

      def test_applies_timeouts_with_multipart_overrides_without_mutating_callers_options
        options = { open_timeout: 5, timeout: 15 }
        client = Client.new('token', 'v25.0', adapter: RecordingAdapter, request_options: options,
                                              multipart_request_options: { timeout: 60 })
        options[:timeout] = 99
        client.send_request(endpoint: 'messages')
        client.send_request(endpoint: 'media', multipart: true)
        normal, multipart = RecordingAdapter.requests.map { |r| r[:options] }

        assert_equal(5, normal.open_timeout)
        assert_equal(15, normal.timeout)
        assert_equal(5, multipart.open_timeout)
        assert_equal(60, multipart.timeout)
      end

      def test_preserves_json_form_multipart_and_logger_with_the_configured_adapter
        output = StringIO.new
        client = Client.new('token', 'v25.0', Logger.new(output), { bodies: false }, adapter: RecordingAdapter)
        client.send_request(endpoint: 'json', params: { text: 'Olá' },
                            headers: { 'Content-Type' => 'application/json' })
        client.send_request(endpoint: 'form', params: { text: 'Olá' })
        File.open('test/fixtures/assets/whatsapp.png', 'rb') do |file|
          client.send_request(endpoint: 'media', params: { file: Faraday::FilePart.new(file, 'image/png') },
                              multipart: true)
        end
        json, form, multipart = RecordingAdapter.requests

        assert_equal('{"text":"Olá"}', json[:body])
        assert_equal('text=Ol%C3%A1', form[:body])
        assert_match(%r{\Amultipart/form-data; boundary=}, multipart[:headers]['Content-Type'])
        assert_respond_to(multipart[:body], :read)
        assert_includes(output.string, '/v25.0/json')
      end

      def test_preserves_keyword_style_logger_options
        output = StringIO.new
        client = Client.new(
          'token', 'v25.0', Logger.new(output),
          bodies: true, headers: false, errors: true,
          log_level: :debug, formatter: Faraday::Logging::Formatter, adapter: RecordingAdapter
        )
        client.send_request(endpoint: 'messages', params: { text: 'logged-message' })

        assert_includes(output.string, 'text=logged-message')
      end

      def test_unknown_positional_logger_options_reach_the_logger
        output = StringIO.new
        client = Client.new('token', 'v25.0', Logger.new(output), { bodies: true, custom_formatter_option: 1 },
                            adapter: RecordingAdapter)
        client.send_request(endpoint: 'messages', params: { text: 'logged-message' })

        assert_includes(output.string, 'text=logged-message')
      end

      def test_rejects_unknown_request_options_when_the_client_is_built
        %i[request_options multipart_request_options].each do |name|
          error = assert_raises(ArgumentError) { Client.new('token', 'v25.0', name => { read_timout: 5 }) }
          assert_includes(error.message, 'read_timout')
        end
      end

      def test_default_adapter_is_read_when_the_connection_is_built
        client = Client.new('token', 'v25.0')
        previous = Faraday.default_adapter
        Faraday.default_adapter = RecordingAdapter
        client.send_request(endpoint: 'messages')

        assert_equal(1, RecordingAdapter.requests.size)
      ensure
        Faraday.default_adapter = previous
      end

      def test_configuration_shares_one_client_with_its_transport_options
        config = WhatsappSdk::Configuration.new('token')
        config.adapter = RecordingAdapter
        config.request_options = { timeout: 7 }
        client = config.client
        client.send_request(endpoint: 'messages')

        assert_same(client, config.client)
        assert_equal(7, RecordingAdapter.requests.first[:options].timeout)
        config.access_token = 'new-token'
        refute_same(client, config.client)
      end

      def test_client_new_uses_the_global_transport_configuration
        middleware_calls = 0
        WhatsappSdk.configure do |config|
          config.adapter = RecordingAdapter
          config.request_options = { timeout: 15 }
          config.multipart_request_options = { timeout: 60 }
          config.middleware = ->(_builder) { middleware_calls += 1 }
        end
        client = Client.new('token', 'v25.0')
        client.send_request(endpoint: 'messages')
        client.send_request(endpoint: 'media', multipart: true)

        assert_equal([15, 60], RecordingAdapter.requests.map { |request| request[:options].timeout })
        assert_equal(2, middleware_calls)
      ensure
        WhatsappSdk.configure do |config|
          config.adapter = nil
          config.request_options = {}
          config.multipart_request_options = {}
          config.middleware = nil
        end
      end

      def test_nil_logger_options_are_treated_as_empty
        Client.new('token', 'v25.0', nil, nil, adapter: RecordingAdapter).send_request(endpoint: 'messages')

        config = WhatsappSdk::Configuration.new('token')
        config.logger_options = nil
        config.adapter = RecordingAdapter
        config.client.send_request(endpoint: 'messages')

        assert_equal(2, RecordingAdapter.requests.size)
      end

      def test_configuration_hashes_cannot_be_edited_in_place
        config = WhatsappSdk::Configuration.new('token')
        options = { timeout: 7 }
        config.request_options = options
        config.client

        assert_raises(FrozenError) { config.request_options[:timeout] = 15 }
        assert_raises(FrozenError) { config.multipart_request_options[:timeout] = 15 }
        assert_raises(FrozenError) { config.logger_options[:bodies] = true }
        refute_predicate(options, :frozen?)
      end

      def test_configuration_rejects_unknown_request_options_when_set
        config = WhatsappSdk::Configuration.new('token')
        %i[request_options multipart_request_options].each do |name|
          error = assert_raises(ArgumentError) { config.public_send(:"#{name}=", { read_timout: 5 }) }
          assert_includes(error.message, 'read_timout')
        end
      end

      def test_middleware_is_added_to_every_connection
        tagger = Class.new(Faraday::Middleware) do
          def on_request(env)
            env.request_headers['X-Middleware'] = 'yes'
          end
        end
        config = WhatsappSdk::Configuration.new('token')
        config.adapter = RecordingAdapter
        config.middleware = ->(builder) { builder.use(tagger) }
        config.client.send_request(endpoint: 'messages')
        config.client.send_request(endpoint: 'media', multipart: true)

        assert_equal(%w[yes yes], RecordingAdapter.requests.map { |r| r[:headers]['X-Middleware'] })
      end

      def test_close_releases_connections_and_allows_new_requests
        client = Client.new('token', 'v25.0', adapter: RecordingAdapter)
        client.send_request(endpoint: 'messages')
        original = RecordingAdapter.requests.first[:adapter]
        client.close
        client.close
        client.send_request(endpoint: 'messages')

        assert_equal([original], RecordingAdapter.closed)
        refute_same(original, RecordingAdapter.requests.last[:adapter])
      end

      def test_rejects_unknown_keywords_instead_of_silently_losing_timeouts
        error = assert_raises(ArgumentError) do
          Client.new('token', 'v25.0', request_option: { timeout: 15 })
        end

        assert_includes(error.message, 'request_option')
      end

      def test_close_attempts_every_connection_and_clears_the_cache_even_when_adapters_fail
        adapter = Class.new(RecordingAdapter) do
          def close
            super
            raise IOError, "close failure #{self.class.closed.length}"
          end
        end
        adapter.requests = []
        adapter.closed = []
        client = Client.new('token', 'v25.0', adapter: adapter)
        client.send_request(endpoint: 'messages')
        client.send_request(endpoint: 'media', multipart: true)
        originals = adapter.requests.map { |request| request[:adapter] }

        error = assert_raises(IOError) { client.close }

        assert_equal('close failure 1', error.message)
        assert_equal(originals, adapter.closed)
        client.close
        client.send_request(endpoint: 'messages')
        refute_includes(originals, adapter.requests.last[:adapter])
      end

      def test_concurrent_first_requests_share_one_adapter_that_close_can_release
        entered = Queue.new
        release = Queue.new
        adapter = Class.new(RecordingAdapter) do
          define_method(:initialize) do |*args, &block|
            super(*args, &block)
            entered << true
            release.pop
          end
        end
        adapter.requests = []
        adapter.closed = []
        client = Client.new('token', 'v25.0', adapter: adapter)
        threads = []
        Timeout.timeout(5) do
          threads << Thread.new { client.send_request(endpoint: 'messages') }
          entered.pop
          threads << Thread.new { client.send_request(endpoint: 'messages') }
          Thread.pass until threads.last.status == 'sleep'
          2.times { release << true }
          threads.each(&:value)
        end
        client.close

        adapters = adapter.requests.map { |request| request[:adapter] }
        assert_equal(2, adapters.size)
        assert_same(adapters.first, adapters.last)
        assert_equal([adapters.first], adapter.closed)
      ensure
        threads&.each { |thread| thread.kill.join }
      end
    end
  end
end

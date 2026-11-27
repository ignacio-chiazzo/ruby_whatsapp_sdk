# frozen_string_literal: true

require 'test_helper'
require 'api/responses/raw_response'

module WhatsappSdk
  module Api
    module Responses
      class RawResponseTest < Minitest::Test
        def test_exposes_status_headers_and_body
          response = RawResponse.new(status: 201, headers: { 'X-Request-Id' => 'abc' }, body: '{"id":"1"}')

          assert_equal(201, response.status)
          assert_equal('{"id":"1"}', response.body)
          assert_equal('abc', response.headers['x-request-id'])
          assert_predicate(response, :success?)
        end

        def test_headers_lookups_ignore_case
          headers = RawResponse.new(status: 200, headers: { 'Retry-After' => '30' }).headers

          assert_equal('30', headers['RETRY-AFTER'])
          assert_equal('30', headers.fetch(:'retry-after'))
          assert(headers.key?('Retry-After'))
          assert_includes(headers, 'retry-after')
          assert_equal('none', headers.fetch('X-Missing', 'none'))
          assert_equal({ 'retry-after' => '30' }, headers.to_h)
          assert_predicate(headers, :frozen?)
        end

        def test_success_is_false_outside_2xx
          refute_predicate(RawResponse.new(status: 302), :success?)
          refute_predicate(RawResponse.new(status: 500), :success?)
        end

        def test_does_not_expose_http_library_methods
          response = RawResponse.new(status: 200)

          refute_respond_to(response, :env)
          assert_raises(NoMethodError) { response.env }
        end
      end
    end
  end
end

# typed: true
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib/whatsapp_sdk', __dir__)

require "minitest/autorun"
require "minitest/assertions"
require 'mocha/minitest'
require "pry"
require "pry-nav"
require "webmock/minitest"
require "errors_helper"
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<ACCESS_TOKEN>') do
    ENV.fetch('WHATSAPP_ACCESS_TOKEN', nil)
  end
end

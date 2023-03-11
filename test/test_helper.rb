# typed: true
# frozen_string_literal: true
require 'simplecov'
SimpleCov.start do
  add_filter %r{^/test/}
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require "minitest/autorun"
require "minitest/assertions"
require 'mocha/minitest'
require "pry"
require "pry-nav"
require "sorbet-runtime"
require "webmock/minitest"

# typed: true
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib/whatsapp_sdk', __dir__)

require "minitest/autorun"
require "minitest/assertions"
require 'mocha/minitest'
require "pry"
require "pry-nav"
require "sorbet-runtime"
require "webmock/minitest"
require "errors_helper"

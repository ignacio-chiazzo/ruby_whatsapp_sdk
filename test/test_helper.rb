# frozen_string_literal: true
# typed: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require "minitest/autorun"
require "minitest/assertions"
require 'mocha/minitest'
require "pry"
require "pry-nav"
require "sorbet-runtime"

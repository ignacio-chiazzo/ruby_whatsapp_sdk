# frozen_string_literal: true
# typed: true

require "zeitwerk"
require "faraday"
require "faraday/multipart"
require "sorbet-runtime"

loader = Zeitwerk::Loader.for_gem
loader.setup

module WhatsappSdk
  class << self
    extend T::Sig

    sig { returns(Configuration) }
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end

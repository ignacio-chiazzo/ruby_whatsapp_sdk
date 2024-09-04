# typed: true
# frozen_string_literal: true

require "zeitwerk"
require "faraday"
require "faraday/multipart"

loader = Zeitwerk::Loader.for_gem
loader.setup

module WhatsappSdk
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end

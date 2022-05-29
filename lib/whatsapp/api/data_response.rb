# frozen_string_literal: true

module Whatsapp
  module Api
    class DataResponse
      attr_reader :raw_data_response

      def initialize(response)
        @raw_data_response = response
      end

      def self.build_from_response(response:) # rubocop:disable Lint/UnusedMethodArgument:
        raise NotImplemented
      end
    end
  end
end

# frozen_string_literal: true
# typed: true

module WhatsappSdk
  module Resource
    class Currency
      # Returns default text if localization fails.
      #
      # @returns fallback_value [String].
      attr_accessor :fallback_value

      # Currency code as defined in ISO 4217.
      #
      # @returns code [String].
      attr_accessor :code

      # Amount multiplied by 1000.
      #
      # @returns code [Float].
      attr_accessor :amount

      def initialize(fallback_value:, code:, amount:)
        @fallback_value = fallback_value
        @code = code
        @amount = amount
      end

      def to_json
        {
          fallback_value: fallback_value,
          code: code,
          amount_1000: amount
        }
      end
    end
  end
end

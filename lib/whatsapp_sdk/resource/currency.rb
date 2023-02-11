# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Currency
      extend T::Sig

      # Returns default text if localization fails.
      #
      # @returns fallback_value [String].
      sig { returns(String) }
      attr_accessor :fallback_value

      # Currency code as defined in ISO 4217.
      #
      # @returns code [String].
      sig { returns(String) }
      attr_accessor :code

      # Amount multiplied by 1000.
      #
      # @returns code [Float].
      sig { returns(T.any(Float, Integer)) }
      attr_accessor :amount

      sig { params(fallback_value: String, code: String, amount: T.any(Float, Integer)).void }
      def initialize(fallback_value:, code:, amount:)
        @fallback_value = fallback_value
        @code = code
        @amount = amount
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
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

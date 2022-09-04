# frozen_string_literal: true
# typed: strict

module WhatsappSdk
  module Resource
    class DateTime
      extend T::Sig

      # Returns default text if localization fails.
      #
      # @returns fallback_value [String].
      sig { returns(String) }
      attr_accessor :fallback_value

      sig { params(fallback_value: String).void }
      def initialize(fallback_value:)
        @fallback_value = fallback_value
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_json
        {
          fallback_value: fallback_value
        }
      end
    end
  end
end

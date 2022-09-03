# frozen_string_literal: true
# typed: true

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

      sig { returns(Hash) }
      def to_json
        {
          fallback_value: fallback_value
        }
      end
    end
  end
end

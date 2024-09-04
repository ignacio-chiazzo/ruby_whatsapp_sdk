# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class DateTime
      # Returns default text if localization fails.
      #
      # @returns fallback_value [String].
      attr_accessor :fallback_value

      def initialize(fallback_value:)
        @fallback_value = fallback_value
      end

      def to_json
        {
          fallback_value: fallback_value
        }
      end
    end
  end
end

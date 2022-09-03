# frozen_string_literal: true
# typed: true

module WhatsappSdk
  module Resource
    class Name
      extend T::Sig

      sig { returns(T.nilable(String)) }
      attr_accessor :formatted_name

      sig { returns(T.nilable(String)) }
      attr_accessor :first_name

      sig { returns(T.nilable(String)) }
      attr_accessor :last_name

      sig { returns(T.nilable(String)) }
      attr_accessor :middle_name

      sig { returns(T.nilable(String)) }
      attr_accessor :suffix

      sig { returns(T.nilable(String)) }
      attr_accessor :prefix

      sig do
        params(
          formatted_name: T.nilable(String), first_name: T.nilable(String),
          last_name: T.nilable(String), middle_name: T.nilable(String),
          suffix: T.nilable(String), prefix: T.nilable(String)
        ).void
      end
      def initialize(
        formatted_name: nil, first_name: nil,
        last_name: nil, middle_name: nil, suffix: nil, prefix: nil
      )
        @formatted_name = formatted_name
        @first_name = first_name
        @last_name = last_name
        @middle_name = middle_name
        @suffix = suffix
        @prefix = prefix
      end

      sig { returns(Hash) }
      def to_h
        {
          formatted_name: @formatted_name,
          first_name: @first_name,
          last_name: @last_name,
          middle_name: @middle_name,
          suffix: @suffix,
          prefix: @prefix
        }
      end
    end
  end
end

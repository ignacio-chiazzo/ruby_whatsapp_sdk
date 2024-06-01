# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveAction
      extend T::Sig

      class Type < T::Enum
        extend T::Sig

        enums do
          ListMessage = new("list_message")
          ReplyButton = new("reply_button")
        end
      end

      # Returns the type of interactive action you want to send.
      #
      # @returns type [Type]. Supported Options are list_message and reply_button.
      sig { returns(Type) }
      attr_accessor :type

      # Returns the buttons of the Action. For reply_button type, it's required.
      #
      # @returns buttons [Array<InteractiveActionReplyButton>] .
      sig { returns(T::Array[InteractiveActionReplyButton]) }
      attr_accessor :buttons

      # Returns the button of the Action. For list_message type, it's required.
      #
      # @returns button [String] .
      sig { returns(String) }
      attr_accessor :button

      # Returns the sections of the Action. For list_message type, it's required.
      #
      # @returns sections [Array<InteractiveActionSection>] .
      sig { returns(T::Array[InteractiveActionSection]) }
      attr_accessor :sections

      # TODO: attr_accessor :catalog_id
      # TODO: attr_accessor :product_retailer_id

      sig { params(reply_button: InteractiveActionReplyButton).void }
      def add_reply_button(reply_button)
        @buttons << reply_button
      end

      sig { params(section: InteractiveActionSection).void }
      def add_section(section)
        @sections << section
      end

      REPLY_BUTTONS_MINIMUM = 1
      REPLY_BUTTONS_MAXIMUM = 3
      LIST_BUTTON_TITLE_MAXIMUM = 20
      LIST_SECTIONS_MINIMUM = 1
      LIST_SECTIONS_MAXIMUM = 10

      sig do
        params(
          type: Type, buttons: T::Array[InteractiveActionReplyButton],
          button: String, sections: T::Array[InteractiveActionSection]
        ).void
      end
      def initialize(type:, buttons: [], button: "", sections: [])
        @type = type
        @buttons = buttons
        @button = button
        @sections = sections
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_json
        json = {}
        case type.serialize
        when "list_message"
          json = { button: button, sections: sections.map(&:to_json) }
        when "reply_button"
          json = { buttons: buttons.map(&:to_json) }
        end

        json
      end

      sig { void }
      def validate
        validate_fields
      end

      private

      sig { void }
      def validate_fields
        case type.serialize
        when "list_message"
          validate_list_message
        when "reply_button"
          validate_reply_button
        end
      end

      sig { returns(T::Array[InteractiveActionSection]) }
      def validate_list_message
        button_length = button.length
        sections_count = sections.length
        unless button_length.positive?
          raise Errors::InvalidInteractiveActionButton,
                "Invalid button in action. Button label is required."
        end

        unless button_length <= LIST_BUTTON_TITLE_MAXIMUM
          raise Errors::InvalidInteractiveActionButton,
                "Invalid length #{button_length} for button. Maximum length: " \
                "#{LIST_BUTTON_TITLE_MAXIMUM} characters."
        end

        unless (LIST_SECTIONS_MINIMUM..LIST_SECTIONS_MAXIMUM).cover?(sections_count)
          raise Errors::InvalidInteractiveActionSection,
                "Invalid length #{sections_count} for sections in action. It should be between " \
                "#{LIST_SECTIONS_MINIMUM} and #{LIST_SECTIONS_MAXIMUM}."
        end

        sections.each(&:validate)
      end

      sig { returns(NilClass) }
      def validate_reply_button
        buttons_count = buttons.length
        unless (REPLY_BUTTONS_MINIMUM..REPLY_BUTTONS_MAXIMUM).cover?(buttons_count)
          raise Errors::InvalidInteractiveActionReplyButton,
                "Invalid length #{buttons_count} for buttons in action. It should be between " \
                "#{REPLY_BUTTONS_MINIMUM} and #{REPLY_BUTTONS_MAXIMUM}."
        end

        button_ids = buttons.map(&:id)
        return if button_ids.length.eql?(button_ids.uniq.length)

        raise Errors::InvalidInteractiveActionReplyButton,
              "Duplicate ids #{button_ids} for buttons in action. They should be unique."
      end
    end
  end
end

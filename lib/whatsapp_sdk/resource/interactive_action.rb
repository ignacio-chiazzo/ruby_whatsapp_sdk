# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveAction
      module Type
        LIST_MESSAGE = "list_message"
        REPLY_BUTTON = "reply_button"

        TYPES = [LIST_MESSAGE, REPLY_BUTTON].freeze

        def valid?(type)
          TYPES.include?(type)
        end
      end

      # Returns the type of interactive action you want to send.
      #
      # @returns type [Type]. Supported Options are list_message and reply_button.
      attr_accessor :type

      # Returns the buttons of the Action. For reply_button type, it's required.
      #
      # @returns buttons [Array<InteractiveActionReplyButton>] .
      attr_accessor :buttons

      # Returns the button of the Action. For list_message type, it's required.
      #
      # @returns button [String] .
      attr_accessor :button

      # Returns the sections of the Action. For list_message type, it's required.
      #
      # @returns sections [Array<InteractiveActionSection>] .
      attr_accessor :sections

      # TODO: attr_accessor :catalog_id
      # TODO: attr_accessor :product_retailer_id

      def add_reply_button(reply_button)
        @buttons << reply_button
      end

      def add_section(section)
        @sections << section
      end

      REPLY_BUTTONS_MINIMUM = 1
      REPLY_BUTTONS_MAXIMUM = 3
      LIST_BUTTON_TITLE_MAXIMUM = 20
      LIST_SECTIONS_MINIMUM = 1
      LIST_SECTIONS_MAXIMUM = 10

      def initialize(type:, buttons: [], button: "", sections: [])
        @type = type
        @buttons = buttons
        @button = button
        @sections = sections
      end

      def to_json
        json = {}
        case type
        when "list_message"
          json = { button: button, sections: sections.map(&:to_json) }
        when "reply_button"
          json = { buttons: buttons.map(&:to_json) }
        end

        json
      end

      def validate
        validate_fields
      end

      private

      def validate_fields
        case type
        when Type::LIST_MESSAGE
          validate_list_message
        when Type::REPLY_BUTTON
          validate_reply_button
        end
      end

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

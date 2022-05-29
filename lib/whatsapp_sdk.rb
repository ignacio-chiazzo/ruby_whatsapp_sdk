# frozen_string_literal: true

# Version
require_relative "whatsapp"

# APIs
require_relative "whatsapp/api/phone_numbers"
require_relative "whatsapp/api/messages"
require_relative "whatsapp/api/client"

# APIs responses
require_relative "whatsapp/api/responses/message_data_response"
require_relative "whatsapp/api/responses/phone_number_data_response"
require_relative "whatsapp/api/responses/phone_numbers_data_response"
require_relative "whatsapp/api/responses/error_response"
require_relative "whatsapp/api/responses/data_response"

# Resources
require_relative "whatsapp/resources/address"
require_relative "whatsapp/resources/contact_response"
require_relative "whatsapp/resources/contact"
require_relative "whatsapp/resources/email"
require_relative "whatsapp/resources/message"
require_relative "whatsapp/resources/name"
require_relative "whatsapp/resources/org"
require_relative "whatsapp/resources/phone_number"
require_relative "whatsapp/resources/url"
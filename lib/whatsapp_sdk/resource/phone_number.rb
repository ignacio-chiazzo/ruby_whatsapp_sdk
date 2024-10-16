# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class PhoneNumber
      attr_accessor :id, :verified_name, :display_phone_number, :quality_rating, :is_pin_enabled,
                    :is_official_business_account, :account_mode, :certificate, :code_verification_status,
                    :eligibility_for_api_business_global_search, :name_status, :new_name_status, :status,
                    :search_visibility, :messaging_limit_tier # , :phone, :wa_id, :type

      def self.from_hash(hash)
        phone_number = PhoneNumber.new
        phone_number.id = hash["id"]
        phone_number.verified_name = hash["verified_name"]
        phone_number.display_phone_number = hash["display_phone_number"]
        phone_number.quality_rating = hash["quality_rating"]
        phone_number.is_pin_enabled = hash["is_pin_enabled"]
        phone_number.is_official_business_account = hash["is_official_business_account"]
        phone_number.account_mode = hash["account_mode"]
        phone_number.certificate = hash["certificate"]
        phone_number.code_verification_status = hash["code_verification_status"]
        phone_number.eligibility_for_api_business_global_search = hash["eligibility_for_api_business_global_search"]
        phone_number.name_status = hash["name_status"]
        phone_number.new_name_status = hash["new_name_status"]
        phone_number.status = hash["status"]
        phone_number.search_visibility = hash["search_visibility"]
        phone_number.messaging_limit_tier = hash["messaging_limit_tier"]

        phone_number
      end

      # rubocop:disable Metrics/PerceivedComplexity
      def ==(other)
        id == other.id &&
          verified_name == other.verified_name &&
          display_phone_number == other.display_phone_number &&
          quality_rating == other.quality_rating &&
          is_pin_enabled == other.is_pin_enabled &&
          is_official_business_account == other.is_official_business_account &&
          account_mode == other.account_mode &&
          certificate == other.certificate &&
          code_verification_status == other.code_verification_status &&
          eligibility_for_api_business_global_search == other.eligibility_for_api_business_global_search &&
          name_status == other.name_status &&
          new_name_status == other.new_name_status &&
          status == other.status &&
          search_visibility == other.search_visibility &&
          messaging_limit_tier == other.messaging_limit_tier
      end
      # rubocop:enable Metrics/PerceivedComplexity
    end
  end
end

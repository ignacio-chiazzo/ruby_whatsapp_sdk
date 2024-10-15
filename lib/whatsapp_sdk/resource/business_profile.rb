# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class BusinessProfile
      VERTICAL_VALUES = %w[
        UNDEFINED OTHER AUTO BEAUTY APPAREL EDU ENTERTAIN EVENT_PLAN FINANCE GROCERY
        GOVT HOTEL HEALTH NONPROFIT PROF_SERVICES RETAIL TRAVEL RESTAURANT NOT_A_BIZ
      ].freeze

      attr_accessor :about, :address, :description, :email, :messaging_product,
                    :profile_picture_url, :vertical, :websites

      def self.from_hash(hash)
        business_profile = BusinessProfile.new
        business_profile.about = hash["about"]
        business_profile.address = hash["address"]
        business_profile.description = hash["description"]
        business_profile.email = hash["email"]
        business_profile.messaging_product = hash["messaging_product"]
        business_profile.profile_picture_url = hash["profile_picture_url"]
        business_profile.vertical = hash["vertical"]
        business_profile.websites = hash["websites"]

        business_profile
      end

      def ==(other)
        about == other.about &&
          address == other.address &&
          description == other.description &&
          email == other.email &&
          messaging_product == other.messaging_product &&
          profile_picture_url == other.profile_picture_url &&
          vertical == other.vertical &&
          websites == other.websites
      end
    end
  end
end

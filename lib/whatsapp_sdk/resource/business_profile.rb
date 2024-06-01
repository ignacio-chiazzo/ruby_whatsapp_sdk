# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class BusinessProfile
      extend T::Sig

      VERTICAL_VALUES = T.let(%w[
        UNDEFINED OTHER AUTO BEAUTY APPAREL EDU ENTERTAIN EVENT_PLAN FINANCE GROCERY
        GOVT HOTEL HEALTH NONPROFIT PROF_SERVICES RETAIL TRAVEL RESTAURANT NOT_A_BIZ
      ].freeze, T::Array[String])
    end
  end
end

# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class AddressType < T::Enum
      enums do
        Home = new("Home")
        Work = new("Work")
      end
    end
  end
end

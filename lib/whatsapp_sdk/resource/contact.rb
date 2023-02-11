# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Contact
      extend T::Sig

      sig { returns(T::Array[Address]) }
      attr_accessor :addresses

      sig { returns(String) }
      attr_accessor :birthday

      sig { returns(T::Array[Email]) }
      attr_accessor :emails

      sig { returns(Name) }
      attr_accessor :name

      sig { returns(Org) }
      attr_accessor :org

      sig { returns(T::Array[PhoneNumber]) }
      attr_accessor :phones

      sig { returns(T::Array[Url]) }
      attr_accessor :urls

      sig do
        params(
          addresses: T::Array[Address], birthday: String, emails: T::Array[Email],
          name: Name, org: Org, phones: T::Array[PhoneNumber], urls: T::Array[Url]
        ).void
      end
      def initialize(addresses:, birthday:, emails:, name:, org:, phones:, urls:)
        @addresses = addresses
        @birthday = birthday
        @emails = emails
        @name = name
        @org = org
        @phones = phones
        @urls = urls
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_h
        {
          addresses: addresses.map(&:to_h),
          birthday: birthday,
          emails: emails.map(&:to_h),
          name: name.to_h,
          org: org.to_h,
          phones: phones.map(&:to_h),
          urls: urls.map(&:to_h)
        }
      end
    end
  end
end

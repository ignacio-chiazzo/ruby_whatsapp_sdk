# frozen_string_literal: true

module Whatsapp
  module Resource
    class Contact
      attr_accessor :addresses, :birthday, :emails, :name, :org, :phones, :urls

      def initialize(addresses:, birthday:, emails:, name:, org:, phones:, urls:)
        @addresses = addresses
        @birthday = birthday
        @emails = emails
        @name = name
        @org = org
        @phones = phones
        @urls = urls
      end

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

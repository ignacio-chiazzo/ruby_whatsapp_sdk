# frozen_string_literal: true

module WhatsappSdk
  module ContactHelper
    def create_addresses
      address1 = Resource::Address.new(
        street: "STREET",
        city: "CITY",
        state: "STATE",
        zip: "ZIP",
        country: "COUNTRY",
        country_code: "COUNTRY_CODE",
        type: Resource::AddressType::WORK
      )

      address2 = Resource::Address.new(
        street: "STREET",
        city: "CITY",
        state: "STATE",
        zip: "ZIP",
        country: "COUNTRY",
        country_code: "COUNTRY_CODE",
        type: Resource::AddressType::WORK
      )

      [address1, address2]
    end

    def create_emails
      email1 = Resource::Email.new(email: "ignacio@gmail.com", type: Resource::AddressType::WORK)
      email2 = Resource::Email.new(email: "ignacio2@gmail.com", type: Resource::AddressType::HOME)

      [email1, email2]
    end

    def create_name
      Resource::Name.new(
        formatted_name: "ignacio chiazzo",
        first_name: "ignacio",
        last_name: "chiazo",
        middle_name: "jose",
        suffix: "ch",
        prefix: "ig"
      )
    end

    def create_org
      Resource::Org.new(company: "ignacioCo", department: "Engineering", title: "ignacioOrg")
    end

    def create_phone_numbers
      phone1 = Resource::PhoneNumberComponent.new(phone: "1234567", type: Resource::AddressType::HOME, wa_id: "1234")
      phone2 = Resource::PhoneNumberComponent.new(phone: "9876543", type: Resource::AddressType::WORK, wa_id: "1234")

      [phone1, phone2]
    end

    def create_urls
      url1 = Resource::Url.new(url: "1234567", type: Resource::AddressType::HOME)
      url2 = Resource::Url.new(url: "1234567", type: Resource::AddressType::WORK)

      [url1, url2]
    end

    def create_contact
      Resource::Contact.new(
        addresses: create_addresses,
        birthday: "2019-01-01",
        emails: create_emails,
        name: create_name,
        org: create_org,
        phones: create_phone_numbers, # fix me
        urls: create_urls
      )
    end
  end
end

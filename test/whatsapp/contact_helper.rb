# typed: strict
# frozen_string_literal: true

module ContactHelper
  extend T::Sig

  sig { returns(T::Array[WhatsappSdk::Resource::Address]) }
  def create_addresses
    address1 = WhatsappSdk::Resource::Address.new(
      street: "STREET",
      city: "CITY",
      state: "STATE",
      zip: "ZIP",
      country: "COUNTRY",
      country_code: "COUNTRY_CODE",
      type: WhatsappSdk::Resource::AddressType::Work
    )

    address2 = WhatsappSdk::Resource::Address.new(
      street: "STREET",
      city: "CITY",
      state: "STATE",
      zip: "ZIP",
      country: "COUNTRY",
      country_code: "COUNTRY_CODE",
      type: WhatsappSdk::Resource::AddressType::Work
    )

    [address1, address2]
  end

  sig { returns(T::Array[WhatsappSdk::Resource::Email]) }
  def create_emails
    email1 = WhatsappSdk::Resource::Email.new(
      email: "ignacio@gmail.com", type: WhatsappSdk::Resource::AddressType::Work
    )

    email2 = WhatsappSdk::Resource::Email.new(
      email: "ignacio2@gmail.com", type: WhatsappSdk::Resource::AddressType::Home
    )

    [email1, email2]
  end

  sig { returns(WhatsappSdk::Resource::Name) }
  def create_name
    WhatsappSdk::Resource::Name.new(
      formatted_name: "ignacio chiazzo",
      first_name: "ignacio",
      last_name: "chiazo",
      middle_name: "jose",
      suffix: "ch",
      prefix: "ig"
    )
  end

  sig { returns(WhatsappSdk::Resource::Org) }
  def create_org
    WhatsappSdk::Resource::Org.new(company: "ignacioCo", department: "Engineering", title: "ignacioOrg")
  end

  sig { returns(T::Array[WhatsappSdk::Resource::PhoneNumber]) }
  def create_phone_numbers
    phone1 = WhatsappSdk::Resource::PhoneNumber.new(
      phone: "1234567", type: WhatsappSdk::Resource::AddressType::Home, wa_id: "1234"
    )
    phone2 = WhatsappSdk::Resource::PhoneNumber.new(
      phone: "1234567", type: WhatsappSdk::Resource::AddressType::Work, wa_id: "1234"
    )

    [phone1, phone2]
  end

  sig { returns(T::Array[WhatsappSdk::Resource::Url]) }
  def create_urls
    url1 = WhatsappSdk::Resource::Url.new(url: "1234567", type: WhatsappSdk::Resource::AddressType::Home)
    url2 = WhatsappSdk::Resource::Url.new(url: "1234567", type: WhatsappSdk::Resource::AddressType::Work)

    [url1, url2]
  end

  sig { returns(WhatsappSdk::Resource::Contact) }
  def create_contact
    WhatsappSdk::Resource::Contact.new(
      addresses: create_addresses,
      birthday: "2019_01_01",
      emails: create_emails,
      name: create_name,
      org: create_org,
      phones: create_phone_numbers,
      urls: create_urls
    )
  end
end

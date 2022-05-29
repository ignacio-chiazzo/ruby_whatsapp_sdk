# frozen_string_literal: true

module ContactHelper
  def create_addresses
    address1 = WhatsappSdk::Resource::Address.new(
      street: "STREET",
      city: "CITY",
      state: "STATE",
      zip: "ZIP",
      country: "COUNTRY",
      country_code: "COUNTRY_CODE",
      type: WhatsappSdk::Resource::Address::ADDRESS_TYPE[:home]
    )
    address2 = WhatsappSdk::Resource::Address.new(
      street: "STREET",
      city: "CITY",
      state: "STATE",
      zip: "ZIP",
      country: "COUNTRY",
      country_code: "COUNTRY_CODE",
      type: WhatsappSdk::Resource::Address::ADDRESS_TYPE[:work]
    )

    [address1, address2]
  end

  def create_emails
    email1 = WhatsappSdk::Resource::Email.new(
      email: "ignacio@gmail.com", type: WhatsappSdk::Resource::Email::EMAIL_TYPE[:work]
    )

    email2 = WhatsappSdk::Resource::Email.new(
      email: "ignacio2@gmail.com", type: WhatsappSdk::Resource::Email::EMAIL_TYPE[:home]
    )

    [email1, email2]
  end

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

  def create_org
    WhatsappSdk::Resource::Org.new(company: "ignacioCo", department: "Engineering", title: "ignacioOrg")
  end

  def create_phones
    phone1 = WhatsappSdk::Resource::PhoneNumber.new(
      phone: "1234567", type: WhatsappSdk::Resource::PhoneNumber::PHONE_NUMBER_TYPE[:home], wa_id: "1234"
    )
    phone2 = WhatsappSdk::Resource::PhoneNumber.new(
      phone: "1234567", type: WhatsappSdk::Resource::PhoneNumber::PHONE_NUMBER_TYPE[:work], wa_id: "1234"
    )

    [phone1, phone2]
  end

  def create_urls
    url1 = WhatsappSdk::Resource::Url.new(url: "1234567", type: WhatsappSdk::Resource::Address::ADDRESS_TYPE[:home])
    url2 = WhatsappSdk::Resource::Url.new(url: "1234567", type: WhatsappSdk::Resource::Address::ADDRESS_TYPE[:work])

    [url1, url2]
  end

  def create_contact
    WhatsappSdk::Resource::Contact.new(
      addresses: create_addresses,
      birthday: "2019_01_01",
      emails: create_emails,
      name: create_name,
      org: create_org,
      phones: create_phones,
      urls: create_urls
    )
  end
end

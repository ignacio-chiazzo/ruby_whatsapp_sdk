# frozen_string_literal: true

module ContactHelper
  def create_addresses
    address1 = Whatsapp::Resource::Address.new(
      street: "STREET",
      city: "CITY",
      state: "STATE",
      zip: "ZIP",
      country: "COUNTRY",
      country_code: "COUNTRY_CODE",
      type: Whatsapp::Resource::Address::ADDRESS_TYPE[:home]
    )
    address2 = Whatsapp::Resource::Address.new(
      street: "STREET",
      city: "CITY",
      state: "STATE",
      zip: "ZIP",
      country: "COUNTRY",
      country_code: "COUNTRY_CODE",
      type: Whatsapp::Resource::Address::ADDRESS_TYPE[:work]
    )

    [address1, address2]
  end

  def create_emails
    email1 = Whatsapp::Resource::Email.new(
      email: "ignacio@gmail.com", type: Whatsapp::Resource::Email::EMAIL_TYPE[:work]
    )

    email2 = Whatsapp::Resource::Email.new(
      email: "ignacio2@gmail.com", type: Whatsapp::Resource::Email::EMAIL_TYPE[:home]
    )

    [email1, email2]
  end

  def create_name
    Whatsapp::Resource::Name.new(
      formatted_name: "ignacio chiazzo",
      first_name: "ignacio",
      last_name: "chiazo",
      middle_name: "jose",
      suffix: "ch",
      prefix: "ig"
    )
  end

  def create_org
    Whatsapp::Resource::Org.new(company: "ignacioCo", department: "Engineering", title: "ignacioOrg")
  end

  def create_phones
    phone1 = Whatsapp::Resource::PhoneNumber.new(
      phone: "1234567", type: Whatsapp::Resource::PhoneNumber::PHONE_NUMBER_TYPE[:home], wa_id: "1234"
    )
    phone2 = Whatsapp::Resource::PhoneNumber.new(
      phone: "1234567", type: Whatsapp::Resource::PhoneNumber::PHONE_NUMBER_TYPE[:work], wa_id: "1234"
    )

    [phone1, phone2]
  end

  def create_urls
    url1 = Whatsapp::Resource::Url.new(url: "1234567", type: Whatsapp::Resource::Address::ADDRESS_TYPE[:home])
    url2 = Whatsapp::Resource::Url.new(url: "1234567", type: Whatsapp::Resource::Address::ADDRESS_TYPE[:work])

    [url1, url2]
  end

  def create_contact
    Whatsapp::Resource::Contact.new(
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

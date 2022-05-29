module ContactHelper
  def create_addresses
    address_1 = Whatsapp::Resource::Address.new(
        street: "STREET",
        city: "CITY",
        state: "STATE",
        zip: "ZIP",
        country: "COUNTRY",
        country_code: "COUNTRY_CODE",
        type: Whatsapp::Resource::Address::ADDRESS_TYPE[:home]
    )
    address_2 = Whatsapp::Resource::Address.new(
        street: "STREET",
        city: "CITY",
        state: "STATE",
        zip: "ZIP",
        country: "COUNTRY",
        country_code: "COUNTRY_CODE",
        type: Whatsapp::Resource::Address::ADDRESS_TYPE[:work]
    )

    [address_1, address_2]
  end

  def create_emails
    email_1 = Whatsapp::Resource::Email.new(
        email: "ignacio@gmail.com", type: Whatsapp::Resource::Email::EMAIL_TYPE[:work]
    )

    email_2 = Whatsapp::Resource::Email.new(
        email: "ignacio2@gmail.com", type: Whatsapp::Resource::Email::EMAIL_TYPE[:home]
    )

    [email_1, email_2]
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
    phone_1 = Whatsapp::Resource::PhoneNumber.new(
        phone: "1234567", type: Whatsapp::Resource::PhoneNumber::PHONE_NUMBER_TYPE[:home], wa_id: "1234"
    )
    phone_2 = Whatsapp::Resource::PhoneNumber.new(
        phone: "1234567", type: Whatsapp::Resource::PhoneNumber::PHONE_NUMBER_TYPE[:work], wa_id: "1234"
    )

    [phone_1, phone_2]
  end

  def create_urls
    url_1 = Whatsapp::Resource::Url.new(url: "1234567", type: Whatsapp::Resource::Address::ADDRESS_TYPE[:home])
    url_2 = Whatsapp::Resource::Url.new(url: "1234567", type: Whatsapp::Resource::Address::ADDRESS_TYPE[:work])

    [url_1, url_2]
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
---
sidebar_position: 5
---

# Business Profile API

The Business Profile API allows you to manage your WhatsApp Business profile information, which is displayed to customers when they interact with your business.

## Overview

Your business profile includes information such as:
- Business description
- Business address
- Business email
- Business website
- Profile photo
- Industry vertical

## Get Business Profile

Retrieve your current business profile information:

```ruby
response = client.business_profiles.get(phone_number_id: 'YOUR_PHONE_NUMBER_ID')

if response.error?
  puts "Error: #{response.error.message}"
else
  profile = response.data
  puts "Business Name: #{profile.business_name}"
  puts "About: #{profile.about}"
  puts "Address: #{profile.address}"
  puts "Email: #{profile.email}"
  puts "Website: #{profile.website}"
  puts "Industry: #{profile.vertical}"
  puts "Profile Photo URL: #{profile.profile_picture_url}"
end
```

### Available Fields

When retrieving a business profile, you can specify which fields to include:

```ruby
# Get specific fields only
response = client.business_profiles.get(
  phone_number_id: 'YOUR_PHONE_NUMBER_ID',
  fields: ['about', 'email', 'website', 'address']
)
```

Available fields:
- `about` - Business description
- `address` - Business address
- `description` - Detailed business description
- `email` - Business email address
- `profile_picture_url` - Profile photo URL
- `website` - Business website URLs
- `vertical` - Industry vertical

## Update Business Profile

Update your business profile information:

```ruby
# Update business description
response = client.business_profiles.update(
  phone_number_id: 'YOUR_PHONE_NUMBER_ID',
  params: {
    about: 'We are a leading provider of high-quality products and exceptional customer service.'
  }
)

if response.error?
  puts "Update failed: #{response.error.message}"
else
  puts "Business profile updated successfully!"
end
```

### Update Multiple Fields

```ruby
# Update multiple fields at once
response = client.business_profiles.update(
  phone_number_id: 'YOUR_PHONE_NUMBER_ID',
  params: {
    about: 'Your trusted partner for innovative solutions',
    email: 'contact@yourbusiness.com',
    website: ['https://www.yourbusiness.com', 'https://shop.yourbusiness.com'],
    address: '123 Business Street, City, State 12345'
  }
)
```

### Update Business Address

```ruby
# Update business address
response = client.business_profiles.update(
  phone_number_id: 'YOUR_PHONE_NUMBER_ID',
  params: {
    address: '456 New Business Ave, Suite 100, New City, State 67890'
  }
)
```

### Update Website URLs

```ruby
# Add multiple website URLs
response = client.business_profiles.update(
  phone_number_id: 'YOUR_PHONE_NUMBER_ID',
  params: {
    website: [
      'https://www.yourbusiness.com',
      'https://support.yourbusiness.com',
      'https://blog.yourbusiness.com'
    ]
  }
)
```

### Update Industry Vertical

```ruby
# Set business industry
response = client.business_profiles.update(
  phone_number_id: 'YOUR_PHONE_NUMBER_ID',
  params: {
    vertical: 'RETAIL'
  }
)
```

Available verticals include:
- `AUTOMOTIVE`
- `BEAUTY_SPA_SALON`
- `CLOTHING`
- `EDUCATION`
- `ENTERTAINMENT`
- `EVENT_PLANNING`
- `FINANCE_BANKING`
- `FOOD_GROCERY`
- `PUBLIC_SERVICE`
- `HOTEL_LODGING`
- `MEDICAL_HEALTH`
- `NON_PROFIT`
- `PROFESSIONAL_SERVICES`
- `REAL_ESTATE`
- `RETAIL`
- `TRAVEL`
- `RESTAURANT`
- `OTHER`

## Complete Profile Setup Example

```ruby
class BusinessProfileSetup
  def initialize(phone_number_id)
    @client = WhatsappSdk::Api::Client.new
    @phone_number_id = phone_number_id
  end

  def setup_complete_profile
    profile_data = {
      about: build_about_text,
      email: ENV['BUSINESS_EMAIL'],
      website: [ENV['BUSINESS_WEBSITE']],
      address: ENV['BUSINESS_ADDRESS'],
      vertical: ENV['BUSINESS_VERTICAL'] || 'RETAIL'
    }

    response = @client.business_profiles.update(
      phone_number_id: @phone_number_id,
      params: profile_data
    )

    if response.error?
      Rails.logger.error "Failed to update business profile: #{response.error.message}"
      false
    else
      Rails.logger.info "Business profile updated successfully"
      true
    end
  end

  def verify_profile_completeness
    response = @client.business_profiles.get(phone_number_id: @phone_number_id)
    
    return false if response.error?

    profile = response.data
    missing_fields = []

    missing_fields << 'about' if profile.about.nil? || profile.about.empty?
    missing_fields << 'email' if profile.email.nil? || profile.email.empty?
    missing_fields << 'website' if profile.website.nil? || profile.website.empty?
    missing_fields << 'address' if profile.address.nil? || profile.address.empty?

    if missing_fields.any?
      puts "Missing required fields: #{missing_fields.join(', ')}"
      false
    else
      puts "✅ Business profile is complete"
      true
    end
  end

  private

  def build_about_text
    company_name = ENV['COMPANY_NAME'] || 'Our Company'
    industry = ENV['BUSINESS_VERTICAL'] || 'business'
    
    "Welcome to #{company_name}! We're dedicated to providing exceptional #{industry.downcase} " \
    "services and products. Contact us anytime for assistance or inquiries."
  end
end

# Usage
setup = BusinessProfileSetup.new(ENV['WHATSAPP_PHONE_NUMBER_ID'])
setup.setup_complete_profile
setup.verify_profile_completeness
```

## Profile Photo Management

While the API doesn't directly support uploading profile photos, you can manage them through the Meta Business Manager and reference them in your application:

```ruby
def check_profile_photo
  response = client.business_profiles.get(
    phone_number_id: ENV['WHATSAPP_PHONE_NUMBER_ID'],
    fields: ['profile_picture_url']
  )

  if response.error?
    puts "Error checking profile photo: #{response.error.message}"
  else
    profile = response.data
    if profile.profile_picture_url && !profile.profile_picture_url.empty?
      puts "✅ Profile photo is set: #{profile.profile_picture_url}"
    else
      puts "⚠️ No profile photo set. Please upload one in Meta Business Manager."
    end
  end
end
```

## Business Hours Management

While not directly supported in the current API, you can include business hours in your about section:

```ruby
def update_about_with_hours
  hours_text = <<~HOURS
    We provide excellent customer service and quality products.
    
    🕒 Business Hours:
    Monday - Friday: 9:00 AM - 6:00 PM
    Saturday: 10:00 AM - 4:00 PM
    Sunday: Closed
    
    📞 Contact us anytime via WhatsApp for support!
  HOURS

  response = client.business_profiles.update(
    phone_number_id: ENV['WHATSAPP_PHONE_NUMBER_ID'],
    params: { about: hours_text }
  )

  if response.error?
    puts "Failed to update hours: #{response.error.message}"
  else
    puts "Business hours updated in profile"
  end
end
```

## Validation and Best Practices

### 1. Validate Profile Data

```ruby
class BusinessProfileValidator
  def self.validate_update_params(params)
    errors = []

    # Validate about text length
    if params[:about] && params[:about].length > 512
      errors << "About text must be 512 characters or less"
    end

    # Validate email format
    if params[:email] && !valid_email?(params[:email])
      errors << "Invalid email format"
    end

    # Validate website URLs
    if params[:website]
      invalid_urls = params[:website].reject { |url| valid_url?(url) }
      if invalid_urls.any?
        errors << "Invalid website URLs: #{invalid_urls.join(', ')}"
      end
    end

    # Validate vertical
    if params[:vertical] && !valid_vertical?(params[:vertical])
      errors << "Invalid business vertical"
    end

    errors
  end

  private

  def self.valid_email?(email)
    /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(email)
  end

  def self.valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end

  def self.valid_vertical?(vertical)
    valid_verticals = %w[
      AUTOMOTIVE BEAUTY_SPA_SALON CLOTHING EDUCATION ENTERTAINMENT
      EVENT_PLANNING FINANCE_BANKING FOOD_GROCERY PUBLIC_SERVICE
      HOTEL_LODGING MEDICAL_HEALTH NON_PROFIT PROFESSIONAL_SERVICES
      REAL_ESTATE RETAIL TRAVEL RESTAURANT OTHER
    ]
    valid_verticals.include?(vertical)
  end
end
```

### 2. Safe Profile Updates

```ruby
def safe_update_profile(phone_number_id, updates)
  # Validate data first
  errors = BusinessProfileValidator.validate_update_params(updates)
  
  if errors.any?
    puts "Validation errors:"
    errors.each { |error| puts "  - #{error}" }
    return false
  end

  # Perform update
  response = client.business_profiles.update(
    phone_number_id: phone_number_id,
    params: updates
  )

  if response.error?
    puts "Update failed: #{response.error.message}"
    false
  else
    puts "Profile updated successfully"
    true
  end
rescue => e
  puts "Unexpected error: #{e.message}"
  false
end
```

### 3. Profile Monitoring

```ruby
class BusinessProfileMonitor
  def initialize
    @client = WhatsappSdk::Api::Client.new
  end

  def check_profile_health(phone_number_id)
    response = @client.business_profiles.get(phone_number_id: phone_number_id)
    
    if response.error?
      puts "❌ Could not retrieve profile: #{response.error.message}"
      return
    end

    profile = response.data
    score = calculate_completeness_score(profile)
    
    puts "📊 Profile Completeness: #{score}%"
    
    if score < 80
      puts "⚠️ Consider improving your profile:"
      suggest_improvements(profile)
    else
      puts "✅ Your business profile looks great!"
    end
  end

  private

  def calculate_completeness_score(profile)
    fields = [:about, :email, :website, :address, :vertical]
    completed = fields.count do |field|
      value = profile.send(field)
      value && !value.to_s.empty?
    end
    
    (completed.to_f / fields.length * 100).round
  end

  def suggest_improvements(profile)
    suggestions = []
    
    suggestions << "Add business description" if profile.about.nil? || profile.about.empty?
    suggestions << "Add business email" if profile.email.nil? || profile.email.empty?
    suggestions << "Add website URL" if profile.website.nil? || profile.website.empty?
    suggestions << "Add business address" if profile.address.nil? || profile.address.empty?
    suggestions << "Set industry vertical" if profile.vertical.nil?
    
    suggestions.each { |suggestion| puts "  • #{suggestion}" }
  end
end

# Usage
monitor = BusinessProfileMonitor.new
monitor.check_profile_health(ENV['WHATSAPP_PHONE_NUMBER_ID'])
```

## Error Handling

```ruby
def handle_profile_errors(response)
  return unless response.error?

  case response.error.code
  when 100 # Invalid parameter
    puts "Invalid parameter in profile update"
  when 200 # Permissions error
    puts "Insufficient permissions to update profile"
  when 131000 # Generic user error
    puts "Profile update error: #{response.error.message}"
  else
    puts "Unexpected error #{response.error.code}: #{response.error.message}"
  end
end
```

## Best Practices

1. **Keep information current**: Regularly update your profile information
2. **Use clear descriptions**: Write clear, helpful business descriptions
3. **Include contact methods**: Provide multiple ways for customers to reach you
4. **Set appropriate industry**: Choose the most accurate vertical for your business
5. **Monitor completeness**: Regularly check that all important fields are filled
6. **Validate data**: Always validate data before sending updates

## Next Steps

- [Phone Numbers API](./phone-numbers.md) - Manage your WhatsApp phone numbers
- [Messages API](./messages.md) - Start messaging customers
- [Templates API](./templates.md) - Create professional message templates
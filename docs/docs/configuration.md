---
sidebar_position: 4
---

# Configuration

Learn how to configure the Ruby WhatsApp SDK for your application.

## Basic Configuration

### Global Configuration (Recommended for Rails)

The recommended way to configure the SDK is using a global configuration block, typically in an initializer:

```ruby
# config/initializers/whatsapp_sdk.rb
WhatsappSdk.configure do |config|
  config.access_token = ENV['WHATSAPP_ACCESS_TOKEN']
  config.api_version = ENV.fetch('WHATSAPP_API_VERSION', 'v17.0')
  config.logger = Rails.logger # Use Rails logger
  config.logger_options = { bodies: true } # Log request/response bodies
end
```

### Instance Configuration

You can also create individual client instances with specific configurations:

```ruby
client = WhatsappSdk::Api::Client.new(
  access_token: 'YOUR_ACCESS_TOKEN',
  api_version: 'v17.0',
  logger: Logger.new(STDOUT),
  logger_options: { headers: true, bodies: false }
)
```

## Configuration Options

### Access Token

Your WhatsApp Business API access token from Meta:

```ruby
config.access_token = 'EAAZAvvr0DZBs0BABRLF8zohP5Epc6pyNu...'
```

**Important**: Never hardcode access tokens in your source code. Use environment variables:

```ruby
config.access_token = ENV['WHATSAPP_ACCESS_TOKEN']
```

### API Version

Specify which version of the WhatsApp Cloud API to use:

```ruby
config.api_version = 'v17.0' # Default: latest stable version
```

Available versions can be found in the [Graph API changelog](https://developers.facebook.com/docs/graph-api/changelog/versions).

### Logger

Configure logging for debugging and monitoring:

```ruby
# Use Rails logger in Rails applications
config.logger = Rails.logger

# Use standard logger in other applications
config.logger = Logger.new(STDOUT)

# Disable logging
config.logger = nil
```

### Logger Options

Control what gets logged:

```ruby
config.logger_options = {
  headers: true,    # Log request/response headers
  bodies: true,     # Log request/response bodies
  log_level: :info  # Set log level
}
```

**Warning**: Be careful when logging request/response bodies in production as they may contain sensitive information.

## Environment Variables

For security and flexibility, use environment variables for configuration:

```bash
# .env file
WHATSAPP_ACCESS_TOKEN=your_access_token_here
WHATSAPP_API_VERSION=v17.0
WHATSAPP_PHONE_NUMBER_ID=your_phone_number_id
WHATSAPP_BUSINESS_ID=your_business_id
```

```ruby
# config/initializers/whatsapp_sdk.rb
WhatsappSdk.configure do |config|
  config.access_token = ENV.fetch('WHATSAPP_ACCESS_TOKEN')
  config.api_version = ENV.fetch('WHATSAPP_API_VERSION', 'v17.0')
end
```

## Rails Configuration

### Using Rails Credentials

For enhanced security in Rails applications:

```bash
# Edit credentials
rails credentials:edit
```

```yaml
# config/credentials.yml.enc
whatsapp:
  access_token: your_access_token_here
  api_version: v17.0
```

```ruby
# config/initializers/whatsapp_sdk.rb
WhatsappSdk.configure do |config|
  config.access_token = Rails.application.credentials.whatsapp[:access_token]
  config.api_version = Rails.application.credentials.whatsapp[:api_version]
  config.logger = Rails.logger
end
```

### Environment-Specific Configuration

```ruby
# config/environments/development.rb
WhatsappSdk.configure do |config|
  config.logger_options = { bodies: true, headers: true }
end

# config/environments/production.rb
WhatsappSdk.configure do |config|
  config.logger_options = { bodies: false, headers: false }
end
```

## Multiple Accounts

If you need to manage multiple WhatsApp Business accounts:

```ruby
class WhatsappService
  def initialize(account_config)
    @client = WhatsappSdk::Api::Client.new(account_config[:access_token])
    @phone_number_id = account_config[:phone_number_id]
  end

  def send_message(recipient, message)
    @client.messages.send_text(
      sender_id: @phone_number_id,
      recipient_number: recipient,
      message: message
    )
  end
end

# Usage
account1 = WhatsappService.new(
  access_token: ENV['ACCOUNT1_ACCESS_TOKEN'],
  phone_number_id: ENV['ACCOUNT1_PHONE_NUMBER_ID']
)

account2 = WhatsappService.new(
  access_token: ENV['ACCOUNT2_ACCESS_TOKEN'],
  phone_number_id: ENV['ACCOUNT2_PHONE_NUMBER_ID']
)
```

## Timeout Configuration

Configure request timeouts:

```ruby
# Custom Faraday configuration
require 'faraday'

custom_faraday = Faraday.new do |builder|
  builder.options.timeout = 30      # 30 seconds timeout
  builder.options.open_timeout = 10  # 10 seconds open timeout
end

client = WhatsappSdk::Api::Client.new(
  access_token: 'YOUR_ACCESS_TOKEN',
  faraday: custom_faraday
)
```

## Proxy Configuration

If you need to use a proxy:

```ruby
require 'faraday'

proxy_faraday = Faraday.new(proxy: 'http://proxy.example.com:8080') do |builder|
  builder.adapter Faraday.default_adapter
end

client = WhatsappSdk::Api::Client.new(
  access_token: 'YOUR_ACCESS_TOKEN',
  faraday: proxy_faraday
)
```

## SSL Configuration

For custom SSL settings:

```ruby
require 'faraday'

ssl_faraday = Faraday.new(ssl: { verify: false }) do |builder|
  builder.adapter Faraday.default_adapter
end

client = WhatsappSdk::Api::Client.new(
  access_token: 'YOUR_ACCESS_TOKEN',
  faraday: ssl_faraday
)
```

## Configuration Validation

Validate your configuration:

```ruby
def validate_whatsapp_config
  required_vars = %w[WHATSAPP_ACCESS_TOKEN WHATSAPP_PHONE_NUMBER_ID]
  
  missing_vars = required_vars.select { |var| ENV[var].nil? || ENV[var].empty? }
  
  if missing_vars.any?
    raise "Missing required environment variables: #{missing_vars.join(', ')}"
  end
  
  # Test the connection
  client = WhatsappSdk::Api::Client.new(ENV['WHATSAPP_ACCESS_TOKEN'])
  response = client.phone_numbers.get(ENV['WHATSAPP_PHONE_NUMBER_ID'])
  
  unless response.error?
    puts "✅ WhatsApp SDK configuration is valid"
  else
    puts "❌ WhatsApp SDK configuration error: #{response.error.message}"
  end
end

# Run validation
validate_whatsapp_config
```

## Best Practices

1. **Security**: Never commit access tokens to version control
2. **Environment Variables**: Use environment variables for all sensitive configuration
3. **Logging**: Be cautious about logging sensitive data in production
4. **API Versions**: Pin to specific API versions for stability
5. **Error Handling**: Always validate configuration before using the client
6. **Testing**: Use separate credentials for testing environments

## Next Steps

- [Examples](./examples.md) - See practical configuration examples
- [API Reference](./api/messages.md) - Start using the configured client
- [Troubleshooting](./troubleshooting.md) - Solve configuration issues
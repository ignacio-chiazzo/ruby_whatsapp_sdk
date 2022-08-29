# frozen_string_literal: true
# typed: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "version"

Gem::Specification.new do |spec|
  spec.name = "whatsapp_sdk"
  spec.version = WhatsappSdk::VERSION
  spec.authors       = ["ignacio-chiazzo"]
  spec.email         = ["ignaciochiazzo@gmail.com"]
  spec.summary       = "Use the Ruby Whatsapp SDK to comunicate with Whatsapp API using the Cloud API"
  spec.description   = <<-DESCRIPTION
    Use the Ruby Whatsapp SDK to comunicate with Whatsapp API using the Cloud API.
    Create bots to send and receive messages using the Whatsapp SDK in a few minutes.
  DESCRIPTION
  spec.homepage      = "https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 1.8.6'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk"
    spec.metadata["changelog_uri"] = "https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/blob/main/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
          "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 12.3.3"

  spec.add_dependency("faraday",  "~> 2.3.0")
  spec.add_dependency("faraday-multipart", "~> 1.0.4")
  spec.add_dependency("oj", "~> 3.13.13")
  spec.add_dependency("zeitwerk", "~> 2.6.0")
  spec.metadata['rubygems_mfa_required'] = 'true'
end

# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in whatsapp_sdk.gemspec
gem("faraday")
gem("faraday-multipart")
gem("oj")

group(:test) do
  gem('mocha')
end

group(:development) do
  gem('pry')
  gem('pry-nav')
  gem('rubocop', require: false)
end

gemspec

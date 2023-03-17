# typed: true
# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem("faraday")
gem("faraday-multipart")
gem("rake", ">= 12.3.3")
gem('sorbet-runtime')
gem("zeitwerk", ">= 2.6.0")

group(:test) do
  gem('mocha')
  gem('rubocop', require: false)
  gem('rubocop-minitest', require: false)
  gem('rubocop-performance', require: false)
  gem('rubocop-sorbet', require: false)
  gem('webmock')
end

group(:development) do
  gem('pry')
  gem('pry-nav')
  gem('sorbet')
  gem('spoom')
  gem('tapioca', require: false)
end

gemspec

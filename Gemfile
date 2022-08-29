# frozen_string_literal: true
# typed: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem("faraday")
gem("faraday-multipart")
gem("oj")
gem("rake", ">= 12.3.3")
gem("zeitwerk", ">= 2.6.0")
gem('sorbet-runtime')

group(:test) do
  gem('mocha')
  gem('rubocop', require: false)
  gem('rubocop-minitest', require: false)
  gem('rubocop-performance', require: false)
end

group(:development) do
  gem('spoom')
  gem('sorbet')
  gem('tapioca', require: false)
  gem('pry')
  gem('pry-nav')
end

gemspec

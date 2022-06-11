# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem("faraday")
gem("faraday-multipart")
gem("oj")
gem("rake", ">= 12.3.3")

group(:test) do
  gem('mocha')
end

group(:development) do
  gem('pry')
  gem('pry-nav')
  gem('rubocop', require: false)
end

gemspec

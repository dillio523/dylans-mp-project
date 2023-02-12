source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
gem 'jsbundling-rails'
gem 'webpack'
ruby "3.1.2"

gem "rest-client"

gem 'smarter_csv', '~> 1.7', '>= 1.7.1'

gem 'database_consistency', group: :development, require: false

gem "font-awesome-sass", "~> 6.1"
gem "sassc-rails"
gem "simple_form", github: "heartcombo/simple_form"
gem "autoprefixer-rails"


# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

gem "active_type"
gem "bcrypt"
gem "bootsnap", require: false
gem "good_migrations"
gem "importmap-rails"
gem "pg", "~> 1.1"
gem "pgcli-rails"
gem "puma", "~> 5.0"
gem "rack-canonical-host"
gem "rails", "~> 7.0.2.4"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"


group :production do
  gem "postmark-rails"
  gem "sidekiq"
end

group :development do
  gem "amazing_print"
  gem "annotate"
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "erb_lint", require: false
  gem "letter_opener"
  gem "rubocop", require: false
  gem "rubocop-minitest", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "web-console"
end

group :development, :test do
  gem "byebug"
  gem "dotenv-rails"
  gem "launchy"
  gem "syntax_suggest"
end

group :test do
  gem "capybara"
  gem "capybara-lockstep"
  gem "minitest-ci", require: false
  gem "selenium-webdriver"
  gem "shoulda-context"
  gem "shoulda-matchers"
  gem "webdrivers"
end

gem "csv", "~> 3.2"

gem "activerecord-import", "~> 1.4"

gem "cssbundling-rails", "~> 1.1"

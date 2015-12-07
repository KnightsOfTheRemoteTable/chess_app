source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.4'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SLIM for the front-end templating language
gem 'slim-rails'

# Use Bootstrap/SCSS for stylesheets
gem 'bootstrap-sass', '~> 3.3.5'
gem 'sass-rails',     '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use Simple Form for easier form generation
gem 'simple_form', '~> 3.2'

# Use Devise for user authentication
gem 'devise'

# jQuery UI for the Rails asset pipeline
gem 'jquery-ui-rails'

group :development do
  # awesome_print gem for more readable output in terminal
  gem 'awesome_print'
  # Use spring to preload the environent for faster tests
  gem 'spring'
  # Adds spring compatibility to rspec
  gem 'spring-commands-rspec'
end

group :development, :test do
  # Use Pry instead of IRB
  gem 'pry-rails'
  gem 'pry-byebug'

  gem 'rspec-rails', '~> 3.0'

  # Use rubocop for linting
  gem 'rubocop', require: false

  # Use Factory Girl for factory support
  gem 'factory_girl_rails'

  # Use faker with factory girl to generate fake data for testing
  gem 'faker'
end

group :test do
  # Use Capybara for acceptance testing
  gem 'capybara', '~> 2.5'

  # Use coveralls for code coverage analysis
  gem 'coveralls', require: false

  # Use shoulda-matchers for easy one-line tests
  gem 'shoulda-matchers'
end

group :production do
  # Use rails_12factor to serve static assets in production
  gem 'rails_12factor'
end

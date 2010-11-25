ENV["RAILS_ENV"] = "test"

# Boot rails application and testing parts ...
require "fixtures/rails_app/config/environment"
require "rails/test_help"
require 'tartare'

load File.join(File.dirname(__FILE__), "schema.rb")
require 'factories'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end

# As we are mocking a Rails Application, we need to load configurations.
Typus.reload!

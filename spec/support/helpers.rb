require 'support/helpers/session_helpers'
RSpec.configure do |config|
  config.include SessionHelpers::ExampleMethods
  config.extend SessionHelpers::ExampleGroupMethods
end

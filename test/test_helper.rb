# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

require 'dotenv-rails'
Dotenv::Railtie.load

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

class ActiveSupport::TestCase
  private

  def credentials
    @credentials ||= Credentials.create!(aws_access_key: ENV.fetch('ACTS_AS_AWS_TEST_ACCESS_KEY'), aws_secret_key: ENV.fetch('ACTS_AS_AWS_TEST_SECRET_KEY'))
  end

  def client
    @client ||= Client.create!(credentials: credentials, aws_region: ENV.fetch('ACTS_AS_AWS_TEST_REGION'))
  end
end

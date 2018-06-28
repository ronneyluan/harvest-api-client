require "bundler/setup"
require "harvest/api/client"
require "dotenv"
require "vcr"
require "time"
require "date"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    Dotenv.load('.env')

    VCR.configure do |config|
      config.cassette_library_dir = "spec/vcr_cassettes"
      config.hook_into :webmock
    end
  end
end

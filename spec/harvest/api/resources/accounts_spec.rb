RSpec.describe Harvest::Api::Resources::Accounts do
  before do
    Harvest::Api::Client.setup do |config|
      config.harvest_access_token = ENV['ACCOUNT_HARVEST_ACCESS_TOKEN']
    end
  end

  subject do
    described_class.new(
      access_token: Harvest::Api::Client.config.harvest_access_token)
  end

  describe "#all" do
    let(:account_attributes) do
      %w(id name product google_sign_in_required)
    end

    it "returns an array of accounts for the given access token" do
      VCR.use_cassette('accounts/all') do
        accounts = subject.all
        expect(accounts).to be_kind_of(Array)
      end
    end

    it "returns the correct account attributes" do
      VCR.use_cassette('accounts/all') do
        accounts = subject.all
        expect(accounts.first.keys).to match_array(account_attributes)
      end
    end
  end
end

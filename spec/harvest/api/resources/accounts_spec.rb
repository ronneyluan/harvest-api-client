RSpec.describe Harvest::Api::Resources::Accounts do
  subject do
    described_class.new(access_token: ENV['HARVEST_USER_ACCESS_TOKEN'])
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

RSpec.describe Harvest::Api::Resources::Users do
  subject do
    described_class.new(access_token: Harvest::Api::Client.config.harvest_access_token,
      account_id: Harvest::Api::Client.config.harvest_account_id)
  end

  let(:user_attributes) do
    %w(id first_name last_name email telephone timezone weekly_capacity
      has_access_to_all_future_projects is_contractor is_admin is_project_manager
      can_see_rates can_create_projects can_create_invoices is_active
      created_at updated_at default_hourly_rate cost_rate roles avatar_url)
  end

  describe '#all' do
    it 'returns an array' do
      VCR.use_cassette("users/all") do
        expect(subject.all).to be_kind_of(Array)
      end
    end

    it 'returns hashes with the correct attributes' do
      VCR.use_cassette("users/all") do
        expect(subject.all.first.keys).to match_array(user_attributes)
      end
    end

    context 'when the a page is passed as parameter' do
      it 'adds the given page to request query' do
        options = { options: { query: { page: 1, per_page: 100 } } }

        expect(subject).to receive(:get).with('/users', options).
          and_call_original

        VCR.use_cassette("users/all_page_1") do
          subject.all(page: 1)
        end
      end

      it 'returns an array' do
        VCR.use_cassette("users/all_page_1") do
          expect(subject.all(page: 1)).to be_kind_of(Array)
        end
      end

      context 'and there is no users in the given page' do
        it 'returns an empty array' do
          VCR.use_cassette("users/all_page_2") do
            expect(subject.all(page: 2)).to be_empty
          end
        end
      end
    end
  end

  describe '#current' do
    it "returns a Hash" do
      VCR.use_cassette('users/current') do
        expect(subject.current).to be_kind_of(Hash)
      end
    end

    it "returns the correct attributes in the Hash" do
      VCR.use_cassette('users/current') do
        expect(subject.current.keys).to match_array(user_attributes)
      end
    end
  end

  describe "#find" do
    let(:id) { subject.all.first['id'] }

    it "returns a Hash" do
      VCR.use_cassette('users/found') do
        expect(subject.find(id)).to be_kind_of(Hash)
      end
    end

    it "returns the correct attributes in the Hash" do
      VCR.use_cassette('users/found') do
        expect(subject.find(id).keys).to match_array(user_attributes)
      end
    end

    context "when the user is not found" do
      it "raises a no found error" do
        VCR.use_cassette('users/not_found') do
          expect {
            subject.find('0')
          }.to raise_error(Harvest::Api::Errors::NotFoundError)
        end
      end
    end
  end

  describe "#active" do
    let(:options) do
      { query: { page: 1, per_page: 100, is_active: true } }
    end

    it "adds is_active to query options" do
      expect(subject).to receive(:get).with('/users', options: options).
        and_call_original

      VCR.use_cassette('users/active') do
        subject.active
      end
    end

    it "returns an array of active users" do
      VCR.use_cassette('users/active') do
        users = subject.active
        users.each do |user|
          expect(user['is_active']).to be_truthy
        end
      end
    end
  end

  describe "#updated_since" do
    let(:user) do
      VCR.use_cassette('users/all') { subject.all.first }
    end
    let(:updated_since) { Time.parse(user['updated_at']) - 60 }
    let(:options) do
      {
        query: {
          page: 1,
          per_page: 100,
          updated_since: updated_since.strftime(Harvest::Api::Client::TIME_FORMAT)
        }
      }
    end

    it "adds updated_at to quer options" do
      expect(subject).to receive(:get).with('/users', options: options).
        and_call_original

      VCR.use_cassette('users/updated_since') do
        subject.updated_since(updated_since)
      end
    end

    it "returns an array of users udpated since the given time" do
      VCR.use_cassette('users/updated_since') do
        users = subject.updated_since(updated_since)
        expect(users).to include(user)
      end
    end

    context "when there is no users updated since the given time" do
      let(:updated_since) { Time.parse(user['updated_at']) + 60 }

      it "returns an empty array" do
        VCR.use_cassette('users/updated_since_empty') do
          users = subject.updated_since(updated_since)
          expect(users).to be_empty
        end
      end
    end
  end
end

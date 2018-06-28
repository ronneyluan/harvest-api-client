RSpec.describe Harvest::Api::Resources::Users do
  subject do
    described_class.new(access_token: ENV['HARVEST_ACCESS_TOKEN'],
      account_id: ENV['HARVEST_ACCOUNT_ID'])
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

    context 'when a page is passed as parameter' do
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
      it "raises a not found error" do
        VCR.use_cassette('users/not_found') do
          expect {
            subject.find('0')
          }.to raise_error(Harvest::Api::Errors::NotFoundError)
        end
      end
    end
  end
end

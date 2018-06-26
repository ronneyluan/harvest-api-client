require  "harvest/api/resources/shared/request_errors"

RSpec.describe Harvest::Api::Resources::Base do
  subject do
    described_class.new(access_token: Harvest::Api::Client.config.harvest_access_token,
      account_id: Harvest::Api::Client.config.harvest_account_id)
  end

  describe "#get" do
    it "returns a parsed response" do
      VCR.use_cassette('users/current') do
        expect(subject.get('/users/me')).to be_kind_of(Hash)
      end
    end

    context "when a block is passed" do
      it "returns the parsed response as a block param" do
        VCR.use_cassette('users/current') do
          subject.get('/users/me') do |response|
            expect(response).to be_kind_of(Hash)
          end
        end
      end
    end

    include_examples "request errors"
  end

  describe "#get_collection" do
    let(:page_attributes) do
      %w(users per_page total_pages total_entries next_page previous_page page links)
    end

    it "returns an array of pages" do
      VCR.use_cassette('users/all') do
        pages = subject.get_collection('/users?page=1&per_page=100')
        expect(pages).to be_kind_of(Array)
        expect(pages.first.keys).to match_array(page_attributes)
      end
    end

    context "when a block is passed" do
      let(:user_attributes) do
        %w(id first_name last_name email telephone timezone weekly_capacity
          has_access_to_all_future_projects is_contractor is_admin is_project_manager
          can_see_rates can_create_projects can_create_invoices is_active
          created_at updated_at default_hourly_rate cost_rate roles avatar_url)
      end

      it "returns a array of the extracted data in the block" do
        VCR.use_cassette('users/all') do
          users = subject.get_collection('/users?page=1&per_page=100') do |response|
            response['users']
          end
          expect(users).to be_kind_of(Array)
          expect(users.first.keys).to match_array(user_attributes)
        end
      end
    end

    context "when there is more than one page for the requested resource" do
      let(:first_page_response) do
        double(
          'HTTPartyResponse',
          body: { 'page' => 1, 'total_pages' => 2, 'next_page' => 2 }
        )
      end

      before do
        allow(HTTParty).to receive(:get).and_return
      end
    end

    include_examples "request errors"
  end
end

RSpec.describe Harvest::Api::Resources::TimeEntries do
  subject do
    described_class.new(access_token: Harvest::Api::Client.config.harvest_access_token,
      account_id: Harvest::Api::Client.config.harvest_account_id)
  end

  let(:time_entry_attributes) do
    %w(id spent_date hours notes is_locked locked_reason is_closed is_billed
      timer_started_at started_time ended_time is_running billable budgeted
      billable_rate cost_rate created_at updated_at user client project task
      user_assignment task_assignment invoice external_reference)
  end

  describe "#all" do
    it "returns an array" do
      VCR.use_cassette("time_entries/all") do
        time_entries = subject.all
        expect(time_entries).to be_kind_of(Array)
      end
    end

    it 'returns hashes with the correct attributes' do
      VCR.use_cassette("time_entries/all") do
        expect(subject.all.first.keys).to match_array(time_entry_attributes)
      end
    end

    context 'when a page is passed as parameter' do
      it 'adds the given page to request query' do
        options = { options: { query: { page: 1, per_page: 100 } } }

        expect(subject).to receive(:get_collection).
          with('/time_entries', options).and_call_original

        VCR.use_cassette("time_entries/all_page_1") do
          subject.all(page: 1)
        end
      end

      context 'and there is no time entries in the given page' do
        it 'returns an empty array' do
          VCR.use_cassette("time_entries/all_page_2_empty") do
            expect(subject.all(page: 2)).to be_empty
          end
        end
      end
    end
  end

  describe "#find" do
    let(:id) { subject.all.first['id'] }

    it "returns a Hash" do
      VCR.use_cassette('time_entries/found') do
        time_entry = subject.find(id)

        expect(time_entry).to be_kind_of(Hash)
      end
    end

    it "returns the correct attributes in the Hash" do
      VCR.use_cassette('time_entries/found') do
        expect(subject.find(id).keys).to match_array(time_entry_attributes)
      end
    end

    context "when no time entry is found with the given id" do
      it "raises a not found error" do
        VCR.use_cassette('time_entries/not_found') do
          expect {
            subject.find('0')
          }.to raise_error(Harvest::Api::Errors::NotFoundError)
        end
      end
    end
  end

  describe "#in_period" do
    let(:to) { Date.parse('2018-06-26') }
    let(:from) { to - 10 }

    it "returns the same object as response" do
      expect(subject.in_period(from, to)).to eq(subject)
    end

    it "adds the period to the request query before performing it" do
      options = { query: { from: from, to: to, page: 1, per_page: 100 } }

      expect(subject).to receive(:get_collection).
        with('/time_entries', options: options).and_call_original

      VCR.use_cassette('time_entries/in_period') do
        subject.in_period(from, to).all
      end
    end
  end
end

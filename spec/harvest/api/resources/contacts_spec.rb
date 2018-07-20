RSpec.describe Harvest::Api::Resources::Contacts do
  subject do
    described_class.new(access_token: ENV['HARVEST_ACCESS_TOKEN'],
      account_id: ENV['HARVEST_ACCOUNT_ID'])
  end

  let(:clients) do
    Harvest::Api::Resources::Clients.new(access_token: ENV['HARVEST_ACCESS_TOKEN'],
      account_id: ENV['HARVEST_ACCOUNT_ID'])
  end

  let(:contact_params) do
    { client_id: clients.all.first['id'], first_name: "Contact",
      last_name: "Name" }
  end

  let(:contact_attributes) do
    %w(id client title first_name last_name email phone_office phone_mobile fax
      created_at updated_at)
  end

  describe "#create" do
    it "returns a hash as response" do
      VCR.use_cassette("contacts/new") do
        response = subject.create(params: contact_params)
        expect(response).to be_kind_of(Hash)
      end
    end

    it "returns the correct attributes" do
      VCR.use_cassette("contacts/new") do
        response = subject.create(params: contact_params)
        expect(response.keys).to match_array(contact_attributes)
      end
    end

    it "returns the created contact" do
      VCR.use_cassette("contacts/new") do
        response = subject.create(params: contact_params)
        expect(response['first_name']).to eq(contact_params[:first_name])
      end
    end
  end

  describe "#all" do
    it "returns an array as response" do
      VCR.use_cassette("contacts/all") do
        expect(subject.all).to be_kind_of(Array)
      end
    end

    it "returns the correct attributes for array items" do
      VCR.use_cassette("contacts/all") do
        expect(subject.all.first.keys).to match_array(contact_attributes)
      end
    end
  end

  describe "#find" do
    let(:id) { subject.all.first['id'] }

    it "returns an array as response" do
      VCR.use_cassette("contacts/found") do
        expect(subject.find(id)).to be_kind_of(Hash)
      end
    end

    it "returns the correct attributes" do
      VCR.use_cassette("contacts/found") do
        expect(subject.find(id).keys).to match_array(contact_attributes)
      end
    end
  end

  describe "#update" do
    let(:id) { subject.all.first['id'] }
    let(:update_params) do
      { last_name: "Updated" }
    end

    it "returns a Hash as response" do
      VCR.use_cassette("contacts/updated") do
        response = subject.update(id, params: update_params)
        expect(response).to be_kind_of(Hash)
      end
    end

    it "returns the correct attributes" do
      VCR.use_cassette("contacts/updated") do
        response = subject.update(id, params: update_params)
        expect(response.keys).to match_array(contact_attributes)
      end
    end

    it "returns the updated contact" do
      VCR.use_cassette("contacts/updated") do
        response = subject.update(id, params: update_params)
        expect(response['last_name']).to eq(update_params[:last_name])
      end
    end
  end

  describe "#destroy" do
    let(:id) { subject.all.first['id'] }

    it "returns the deleted contact as response" do
      VCR.use_cassette("contacts/destroyed") do
        response = subject.destroy(id)
        expect(response.keys).to match_array(contact_attributes)
      end
    end
  end
end

RSpec.shared_examples "request errors" do
  context "when the user does not have access authorization" do
    let(:unauthorized_response) do
      double('HTTPartyResponse', code: 403)
    end

    before do
      allow(HTTParty).to receive(:get).and_return(unauthorized_response)
    end

    it "raises an unauthorized request error" do
      expect {
        subject.get('/users')
      }.to raise_error(Harvest::Api::Errors::UnauthorizedError)
    end
  end

  context "when the requested resource is not found" do
    let(:not_found_response) do
      double('HTTPartyResponse', code: 404)
    end

    before do
      allow(HTTParty).to receive(:get).and_return(not_found_response)
    end

    it "raises a not found error" do
      expect {
        subject.get('/users/0')
      }.to raise_error(Harvest::Api::Errors::NotFoundError)
    end
  end

  context "when the request can't be processed" do
    let(:unprocessable_response) do
      double('HTTPartyResponse', code: 422)
    end

    before do
      allow(HTTParty).to receive(:get).and_return(unprocessable_response)
    end

    it "raises an unprocessable request error" do
      expect {
        subject.get('/users?updated_since=test')
      }.to raise_error(Harvest::Api::Errors::UnprocessableEntityError)
    end
  end

  context "when the request limit is reached" do
    let(:throttled_response) do
      double('HTTPartyResponse', code: 429)
    end

    before do
      allow(HTTParty).to receive(:get).and_return(throttled_response)
    end

    it "raises an throttled request error" do
      expect {
        subject.get('/users')
      }.to raise_error(Harvest::Api::Errors::ThrottledRequestError)
    end
  end

  context "when an internal server error happens" do
    let(:server_error_response) do
      double('HTTPartyResponse', code: 500)
    end

    before do
      allow(HTTParty).to receive(:get).and_return(server_error_response)
    end

    it "raises an server error" do
      expect {
        subject.get('/users')
      }.to raise_error(Harvest::Api::Errors::ServerError)
    end
  end

  context "when an unknown error happens" do
    let(:unknown_error_response) do
      double('HTTPartyResponse', code: 503)
    end

    before do
      allow(HTTParty).to receive(:get).and_return(unknown_error_response)
    end

    it "raises an server error" do
      expect {
        subject.get('/users')
      }.to raise_error(Harvest::Api::Errors::UnknownError)
    end
  end
end

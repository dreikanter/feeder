require "rails_helper"

RSpec.describe FreefeedClientBuilder do
  subject(:service) { described_class }

  let(:expected_base_url) { "http://candy.freefeed.net" }
  let(:expected_token) { "TOKEN" }

  before do
    allow(ENV).to receive(:[]).with("FREEFEED_BASE_URL").and_return(expected_base_url)
    allow(ENV).to receive(:[]).with("FREEFEED_TOKEN").and_return(expected_token)
  end

  describe ".call" do
    subject(:result) { service.call }

    it { expect(result).to be_a(Freefeed::Client) }
    it { expect(result.token).to eq(expected_token) }
    it { expect(result.base_url).to eq(expected_base_url) }
  end

  describe ".base_url" do
    it { expect(service.base_url).to eq(expected_base_url) }
  end
end

require "rails_helper"

RSpec.describe NitterInstancesFetcher do
  subject(:service) { described_class }

  let(:content) { file_fixture("nitter_instances_wiki_page.html").read }
  let(:expected) { JSON.parse(file_fixture("nitter_instances_wiki_page.json").read) }

  it "fetches expected urls" do
    stub_request(:get, service::PUBLIC_INSTANCES_WIKI_PAGE_URL).to_return(body: content)
    expect(service.new.call).to match_array(expected)
  end
end

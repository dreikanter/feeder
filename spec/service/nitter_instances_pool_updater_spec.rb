require "rails_helper"

RSpec.describe NitterInstancesPoolUpdater do
  subject(:service) { described_class }

  let(:expected) { JSON.parse(file_fixture("nitter_instances_wiki_page.json").read) }
  let(:imported_urls) { ServiceInstance.where(state: :enabled).pluck(:url) }

  before do
    ServiceInstance.delete_all

    stub_request(:get, NitterInstancesFetcher::PUBLIC_INSTANCES_WIKI_PAGE_URL)
      .to_return(body: file_fixture("nitter_instances_wiki_page.html").read)

    service.call
  end

  it "imports instances" do
    expect(imported_urls).to match_array(expected)
  end

  it "stays idempotent" do
    expect { service.call }.not_to(change { ServiceInstance.pluck(:id, :service_type, :url, :state) })
  end
end

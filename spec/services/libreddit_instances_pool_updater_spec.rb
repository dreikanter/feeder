require "rails_helper"

RSpec.describe LibredditInstancesPoolUpdater do
  subject(:service_call) { described_class.new.call }

  let(:expected_urls) { JSON.parse(libreddit_instances_data).fetch("instances").filter_map { _1["url"] } }
  let(:imported_urls) { ServiceInstance.where(state: :enabled).pluck(:url) }
  let(:libreddit_instances_data) { file_fixture("libreddit_instances.json").read }

  before do
    ServiceInstance.delete_all

    stub_request(:get, "https://raw.githubusercontent.com/libreddit/libreddit-instances/master/instances.json")
      .to_return(body: libreddit_instances_data)

    stub_request(:get, %r{/r/adventuretime$}).to_return(status: 200)
    service_call
  end

  it "imports instances" do
    expect(imported_urls).to match_array(expected_urls)
  end

  it "stays idempotent" do
    expect { service_call }.not_to(change { ServiceInstance.pluck(:id, :service_type, :url, :state) })
  end
end

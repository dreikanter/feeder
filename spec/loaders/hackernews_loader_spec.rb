require "rails_helper"
require "support/shared_hackernews_stubs"

RSpec.describe HackernewsLoader do
  subject(:loader) { described_class.new(feed) }

  let(:feed) { create(:feed, loader: "hackernews") }
  let(:expected) { JSON.parse(file_fixture("feeds/hackernews/expected_loader_result.json").read) }

  include_context "with hackernews stubs"

  it "fetches stories" do
    expect(loader.content).to eq(expected)
  end

  it "caches stories" do
    freeze_time do
      # The first load caches the sories
      loader.content

      remove_request_stub(stub_story_requests)

      # Repeating load to see if it will attempt to repeat loading sories,
      # causing WebMock to raise after the stub removal
      loader.content
    end
  end
end

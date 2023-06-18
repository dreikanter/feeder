require "rails_helper"
require "support/shared_hackernews_stubs"

RSpec.describe HackernewsLoader do
  include_examples "hackernews stubs"

  subject(:loader) { described_class }

  let(:feed) { create(:feed, loader: "hackernews") }
  let(:expected) { JSON.parse(file_fixture("feeds/hackernews/expected_loader_result.json").read) }

  it "fetches stories" do
    expect(loader.call(feed)).to eq(expected)
  end

  it "caches stories" do
    freeze_time do
      # The first load caches the sories
      loader.call(feed)

      remove_request_stub(stub_story_requests)

      # Repeating load to see if it will attempt to repeat loading sories,
      # causing WebMock to raise after the stub removal
      expect { loader.call(feed) }.not_to raise_error
    end
  end
end

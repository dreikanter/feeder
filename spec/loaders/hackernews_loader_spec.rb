require "rails_helper"
require "support/shared_hackernews_stubs"

RSpec.describe HackernewsLoader do
  subject(:load_content) { described_class.new(feed).content }

  let(:feed) { create(:feed, loader: "hackernews") }
  let(:expected) { JSON.parse(file_fixture("feeds/hackernews/expected_loader_result.json").read) }

  include_context "with hackernews stubs"

  it "fetches stories" do
    expect(load_content).to eq(expected)
  end

  it "caches stories" do
    freeze_time do
      # The first load caches the sories
      load_content

      remove_request_stub(stub_story_requests)

      # Repeating load to see if it will attempt to repeat loading sories,
      # causing WebMock to raise after the stub removal
      expect { load_content }.not_to raise_error
    end
  end
end

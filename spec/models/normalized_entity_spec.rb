require "rails_helper"

RSpec.describe NormalizedEntity do
  subject(:model) { described_class }

  let(:feed) { create(:feed, after: import_threshold) }
  let(:import_threshold) { 1.day.ago }
  let(:one_day) { 1.day.seconds.to_i }

  before { freeze_time }

  describe "#==" do
    let(:instance) { model.new }

    it { expect(instance).to eq(instance.dup) }
  end

  describe "#as_json" do
    let(:expected) do
      {
        "feed_id" => "FEED_ID",
        "uid" => "UID",
        "link" => "LINK",
        "published_at" => published_at.to_time.to_s,
        "text" => "TEST",
        "attachments" => ["https://example.com/image.jpg"],
        "comments" => ["I'm a comment"],
        "validation_errors" => []
      }
    end

    let(:instance) do
      model.new(
        feed_id: "FEED_ID",
        uid: "UID",
        link: "LINK",
        published_at: published_at,
        text: "TEST",
        attachments: ["https://example.com/image.jpg"],
        comments: ["I'm a comment"],
        validation_errors: []
      )
    end

    let(:published_at) { Time.current }

    it { expect(instance.as_json).to eq(expected) }
  end
end

require "rails_helper"

RSpec.describe SparklineBuilder do
  subject(:sparkline) { described_class.new(feed, start_date: start_date, end_date: end_date).create_or_update }

  let(:feed) { create(:feed) }
  let(:start_date) { Date.parse("2023-06-16") }
  let(:end_date) { Date.parse("2023-06-20") }

  let(:sample_post_amounts) do
    {
      DateTime.parse("2023-06-16 01:00:00 +0000") => 1,
      DateTime.parse("2023-06-18 01:00:00 +0000") => 5,
      DateTime.parse("2023-06-20 01:00:00 +0000") => 2
    }
  end

  let(:expected) do
    [
      {"date" => Date.parse("2023-06-16"), "value" => 1, "bucket" => 1, "sparky" => "▂"},
      {"date" => Date.parse("2023-06-17"), "value" => 0, "bucket" => 0, "sparky" => " "},
      {"date" => Date.parse("2023-06-18"), "value" => 5, "bucket" => 7, "sparky" => "█"},
      {"date" => Date.parse("2023-06-19"), "value" => 0, "bucket" => 0, "sparky" => " "},
      {"date" => Date.parse("2023-06-20"), "value" => 2, "bucket" => 3, "sparky" => "▄"}
    ]
  end

  before do
    sample_post_amounts.each do |timestamp, posts_count|
      create_list(:post, posts_count, feed: feed, created_at: timestamp)
    end
  end

  it "generates sparkline for a feed" do
    expect(sparkline).to be_a(Sparkline)
    expect(sparkline.feed).to eq(feed)
    expect(sparkline.points).to eq(expected)
  end
end

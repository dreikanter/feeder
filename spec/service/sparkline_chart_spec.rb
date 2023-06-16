require "rails_helper"

RSpec.describe SparklineChart do
  subject(:sparkline) do
    described_class.new(
      timeline: timeline,
      start_date: start_date,
      end_date: end_date
    ).generate
  end

  let(:timeline) { {} }
  let(:start_date) { timeline.keys.min }
  let(:end_date) { timeline.keys.max }

  context "when on a happy path" do
    let(:timeline) do
      {
        Date.parse("2023-06-01") => 0,
        Date.parse("2023-06-02") => 1,
        Date.parse("2023-06-03") => 55,
        Date.parse("2023-06-04") => 20,
        Date.parse("2023-06-05") => 77
      }
    end

    let(:expected) do
      [
        {date: Date.parse("2023-06-01"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-02"), value: 1, bucket: 0, sparky: "▁"},
        {date: Date.parse("2023-06-03"), value: 55, bucket: 5, sparky: "▆"},
        {date: Date.parse("2023-06-04"), value: 20, bucket: 2, sparky: "▃"},
        {date: Date.parse("2023-06-05"), value: 77, bucket: 7, sparky: "█"}
      ]
    end

    it "generates sparkline" do
      expect(sparkline).to eq(expected)
    end
  end

  context "with missing data points" do
    let(:timeline) do
      {
        Date.parse("2023-06-01") => 0,
        Date.parse("2023-06-03") => 55,
        Date.parse("2023-06-05") => 77
      }
    end

    let(:expected) do
      [
        {date: Date.parse("2023-06-01"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-02"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-03"), value: 55, bucket: 5, sparky: "▆"},
        {date: Date.parse("2023-06-04"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-05"), value: 77, bucket: 7, sparky: "█"}
      ]
    end

    it "fills the gaps" do
      expect(sparkline).to eq(expected)
    end
  end

  context "with empty dates range" do
    let(:start_date) { Date.parse("2023-06-01") }
    let(:end_date) { Date.parse("2023-06-05") }

    let(:expected) do
      [
        {date: Date.parse("2023-06-01"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-02"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-03"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-04"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-05"), value: 0, bucket: 0, sparky: " "}
      ]
    end

    it "generates blank chart" do
      expect(sparkline).to eq(expected)
    end
  end

  context "with only one date" do
    let(:timeline) do
      {
        Date.parse("2023-06-01") => 55
      }
    end

    let(:expected) do
      [
        {date: Date.parse("2023-06-01"), value: 55, bucket: 4, sparky: "▅"}
      ]
    end

    it "returns no data points" do
      expect(sparkline).to eq(expected)
    end
  end

  context "with incorrect dates range" do
    let(:start_date) { Date.parse("2023-06-01") }
    let(:end_date) { start_date - 1.day }

    it "returns no data points" do
      expect(sparkline).to be_empty
    end
  end

  context "with incorrect value" do
    let(:timeline) do
      {
        Date.parse("2023-06-01") => 10,
        Date.parse("2023-06-02") => -10,
        Date.parse("2023-06-03") => 10
      }
    end

    let(:expected) do
      [
        {date: Date.parse("2023-06-01"), value: 10, bucket: 7, sparky: "█"},
        {date: Date.parse("2023-06-02"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-03"), value: 10, bucket: 7, sparky: "█"}
      ]
    end

    it "ignores negatives" do
      expect(sparkline).to eq(expected)
    end
  end
end

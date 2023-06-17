require "rails_helper"

RSpec.describe SparklineChart do
  subject(:sparkline) { described_class.new(timeline).generate }

  let(:timeline) { {} }

  context "when on a happy path" do
    let(:timeline) do
      {
        Date.parse("2023-06-01") => 0,
        Date.parse("2023-06-02") => 1,
        Date.parse("2023-06-03") => 42,
        Date.parse("2023-06-04") => 20,
        Date.parse("2023-06-05") => 77
      }
    end

    let(:expected) do
      [
        {date: Date.parse("2023-06-01"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-02"), value: 1, bucket: 0, sparky: "▁"},
        {date: Date.parse("2023-06-03"), value: 42, bucket: 4, sparky: "▅"},
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
        Date.parse("2023-06-03") => 42,
        Date.parse("2023-06-05") => 77
      }
    end

    let(:expected) do
      [
        {date: Date.parse("2023-06-01"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-02"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-03"), value: 42, bucket: 4, sparky: "▅"},
        {date: Date.parse("2023-06-04"), value: 0, bucket: 0, sparky: " "},
        {date: Date.parse("2023-06-05"), value: 77, bucket: 7, sparky: "█"}
      ]
    end

    it "fills the gaps" do
      expect(sparkline).to eq(expected)
    end
  end

  context "with empty timeline" do
    it "generates empty chart" do
      expect(sparkline).to be_empty
    end
  end

  context "with only one date" do
    let(:timeline) do
      {
        Date.parse("2023-06-01") => 42
      }
    end

    let(:expected) do
      [
        {date: Date.parse("2023-06-01"), value: 42, bucket: 4, sparky: "▅"}
      ]
    end

    it "presents the value as an verage" do
      expect(sparkline).to eq(expected)
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

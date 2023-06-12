require "rails_helper"

RSpec.describe DataPoint do
  subject(:model) { described_class }

  let(:data_point) { create(:data_point, series: series) }
  let(:series) { create(:data_point_series) }
  let(:random_timestampt) { [3.hours.ago, 1.hour.ago, 2.hours.ago] }

  it "valid" do
    assert(model.new(series: DataPointSeries.new).valid?)
  end

  it "loads records for series" do
    expect([data_point]).to eq(model.for(series.name))
  end

  it "maintains chronological order scope" do
    freeze_time do
      data_points = random_timestampt.map { |created_at| create(:data_point, series: series, created_at: created_at) }
      ordered_timestamps = DataPoint.for(series.name).ordered_by_created_at.pluck(:created_at)
      expect(random_timestampt.sort.reverse).to eq(ordered_timestamps)
    end
  end
end

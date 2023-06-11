require 'rails_helper'

RSpec.describe CreateDataPoint do
  subject(:service) { described_class }

  let(:series) { :test_series }

  let(:details) do
    {
      number: 9,
      string: 'banana',
      array: %w[coconut],
      nested_object: { 'hello' => 'world' }
    }
  end

  let(:timestamp) { 1.day.ago }

  it 'create data point' do
    data_point = service.call(series)
    expect(data_point).to be_a(DataPoint)
    expect(data_point).to be_persisted
  end

  it 'create series reference' do
    expect { service.call(series) }.to(change { DataPointSeries.exists?(name: series) }.from(false).to(true))
  end

  it 'overwrite creation timestamp' do
    freeze_time do
      data_point = service.call(series, created_at: timestamp)
      expect(data_point.created_at).to eq(timestamp)
    end
  end

  it 'persist details' do
    data_point = service.call(series, details: details)
    expect(data_point.details).to eq(details.stringify_keys)
  end
end

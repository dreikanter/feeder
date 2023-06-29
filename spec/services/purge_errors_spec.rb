require "rails_helper"

RSpec.describe PurgeErrors do
  subject(:service) { described_class }

  let(:sample_threshold) { 1.months.ago }

  before { freeze_time }

  it "deletes old errors" do
    error = create(:error, created_at: sample_threshold - 1.second)
    subject.call(before: sample_threshold)
    expect(Error.where(id: error.id)).not_to exist
  end

  it "keep recent errors" do
    error = create(:error, created_at: sample_threshold + 1.second)
    subject.call(before: sample_threshold)
    expect(Error.where(id: error.id)).to exist
  end
end

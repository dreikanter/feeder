require "rails_helper"

RSpec.describe DataPointSeries do
  subject(:model) { build(:data_point_series) }

  it "is valid" do
    expect(model).to be_valid
  end
end

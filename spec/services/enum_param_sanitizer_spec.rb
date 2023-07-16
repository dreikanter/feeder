require "rails_helper"

RSpec.describe EnumParamSanitizer do
  subject(:service) { described_class }

  it "returns valid value" do
    value = service.call("asc", default: "desc", available: %w[asc desc])
    expect(value).to eq("asc")
  end

  it "returns default when param is missing" do
    value = service.call(nil, default: "desc", available: %w[asc desc])
    expect(value).to eq("desc")
  end

  it "returns default when param is not valid" do
    value = service.call("banana", default: "desc", available: %w[asc desc])
    expect(value).to eq("desc")
  end
end

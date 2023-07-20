require "rails_helper"

RSpec.describe ClassResolver do
  subject(:service) { described_class }

  it "resolves a class" do
    expect(service.new("http", suffix: "loader").resolve).to eq(HttpLoader)
  end

  it "raises when class not found" do
    expect { service.new("missing", suffix: "loader").resolve }.to raise_error(NameError)
  end

  it "returns fallback value" do
    expect(service.new("missing", fallback: "fallback").resolve).to eq("fallback")
  end
end

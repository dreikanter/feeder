require "rails_helper"

RSpec.describe ClassResolver do
  describe "initialization" do
    it "sets expected parameters" do
      resolver = described_class.new("test", suffix: "suffix")
      expect(resolver.class_name).to eq("test")
      expect(resolver.suffix).to eq("suffix")
    end

    it "allows suffix to be nil" do
      resolver = described_class.new("test")
      expect(resolver.class_name).to eq("test")
      expect(resolver.suffix).to be_nil
    end
  end

  describe "#resolve" do
    it "resolves class by name" do
      stub_const("TestService", Class.new)
      resolver = described_class.new("test_service")
      expect(resolver.resolve).to eq(TestService)
    end

    it "resolves class with suffix" do
      stub_const("TestService", Class.new)
      resolver = described_class.new("test", suffix: "service")
      expect(resolver.resolve).to eq(TestService)
    end

    it "raises a NameError for missing class" do
      resolver = described_class.new("non_existent")
      expect { resolver.resolve }.to raise_error(NameError)
    end
  end
end

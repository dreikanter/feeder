require "rails_helper"

RSpec.describe FeedSanitizer do
  subject(:service) { described_class }

  let(:sample_config) do
    {
      name: "xkcd",
      after: "Tue, 18 Sep 2018 00:00:00 +0000",
      import_limit: 10,
      normalizer: "xkcd",
      options: {},
      processor: "xkcd",
      url: "http://xkcd.com/rss.xml",
      refresh_interval: 1800
    }
  end

  let(:minimal_config) do
    {
      name: "dilbert"
    }
  end

  it "returns a Hash" do
    result = service.call(**sample_config)
    expect(result).to be_a(Hash)
  end

  it "requires name" do
    expect { service.call(**sample_config.except(:name)) }.to raise_error(KeyError)
  end

  it "parses timestamp value" do
    expect(service.call(**sample_config)[:after]).to be_a(DateTime)
  end

  it "parses integers" do
    values = service.call(**sample_config).slice(:import_limit, :refresh_interval).values
    expect(values).to all be_a(Integer)
  end

  it "omits undefined attrubutes" do
    expect(service.call(**minimal_config)).to eq(minimal_config)
  end
end

require "rails_helper"

RSpec.describe FeedSanitizer do
  subject(:service) { described_class }

  let(:sample_feed_config) { YAML.load_file(file_fixture("sample_feeds.yml")).first.symbolize_keys }

  let(:expected) do
    {
      name: "xkcd",
      enabled: true,
      attributes: {
        after: DateTime.parse(sample_feed_config[:after]),
        import_limit: 10,
        loader: "http",
        normalizer: "xkcd",
        options: {"sample_option" => "option_value"},
        processor: "rss",
        url: "https://xkcd.com/rss.xml",
        refresh_interval: 1800,
        source: "https://xkcd.com",
        description: "Feed description",
        disabling_reason: "Sample reason"
      }
    }
  end

  let(:minimal_config) do
    {
      name: "dilbert"
    }
  end

  let(:minimal_config_expected) do
    {
      name: "dilbert",
      enabled: true,
      attributes: {options: {}}
    }
  end

  it "returns expected result" do
    expect(service.call(**sample_feed_config)).to eq(expected)
  end

  it "requires name" do
    expect { service.call }.to raise_error(KeyError, /option 'name' is required/)
  end

  it "omits undefined attributes" do
    expect(service.call(**minimal_config)).to eq(minimal_config_expected)
  end
end

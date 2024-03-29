require "rails_helper"
require_relative "../support/factory_bot"
require_relative "../support/faulty_loader"
require_relative "../support/faulty_normalizer"
require_relative "../support/faulty_processor"
require_relative "../support/test_loader"
require_relative "../support/test_processor"
require_relative "../support/test_normalizer"
require_relative "../support/time_helpers"

RSpec.describe ProcessFeed do
  subject(:service) { described_class }

  let(:feed_with_faulty_loader) do
    create(
      :feed,
      loader: "faulty",
      processor: "test",
      normalizer: "test"
    )
  end

  let(:feed_with_faulty_processor) do
    create(
      :feed,
      loader: "test",
      processor: "faulty",
      normalizer: "test"
    )
  end

  let(:feed_with_faulty_normalizer) do
    create(
      :feed,
      loader: "test",
      processor: "test",
      normalizer: "faulty"
    )
  end

  it "increments error counters when loader fails" do
    expect { service.new(feed_with_faulty_loader).process }.to increment_error_counters(feed_with_faulty_loader)
  end

  it "dumps feed error when loader fails" do
    expect { service.new(feed_with_faulty_loader).process }.to change { errors_count(feed_with_faulty_loader) }.by(1)
  end

  it "increments error counters when processor fails" do
    expect { service.new(feed_with_faulty_processor).process }.to increment_error_counters(feed_with_faulty_processor)
  end

  it "dumps feed error when processor fails" do
    expect { service.new(feed_with_faulty_processor).process }.to change { errors_count(feed_with_faulty_processor) }.by(1)
  end

  it "does not create posts on normalization error" do
    expect { service.new(feed_with_faulty_normalizer).process }.not_to change(Post, :count)
  end

  def increment_error_counters(feed)
    change { feed.reload.attributes.slice("errors_count", "total_errors_count") }
      .from({"errors_count" => 0, "total_errors_count" => 0})
      .to({"errors_count" => 1, "total_errors_count" => 1})
  end

  def errors_count(target)
    Error.where(target: target).count
  end
end

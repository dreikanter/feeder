require "rails_helper"

RSpec.describe BaseLoader do
  subject(:loader) { described_class }

  let(:feed) { build(:feed) }

  it "is abstract" do
    expect { loader.call(feed) }.to raise_error(StandardError)
  end
end

require "rails_helper"

RSpec.describe BaseLoader do
  subject(:load_content) { described_class.new(feed).content }

  let(:feed) { build(:feed) }

  it { expect { load_content }.to raise_error(AbstractMethodError) }
end

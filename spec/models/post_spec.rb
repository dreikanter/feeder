require "rails_helper"

RSpec.describe Post do
  subject(:model) { described_class }

  let(:post) { create(:post) }
  let(:blank_post) { model.new }

  it "validates" do
    expect(post).to be_valid
  end

  it "requires mandatory attributes presense" do
    expect(blank_post).not_to be_valid
    expect(blank_post.errors.attribute_names).to match_array(%i[feed uid link published_at])
  end
end

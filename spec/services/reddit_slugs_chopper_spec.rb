require "rails_helper"

RSpec.describe RedditSlugsChopper do
  subject(:service) { described_class }

  let(:non_ascii_url) { "https://www.reddit.com/r/worldnews/comments/11yg2e7/germany_shots_fired_at_police_in_reichsbürger/" }
  let(:expected_safe_url) { "https://www.reddit.com/r/worldnews/comments/11yg2e7/" }

  it { expect(expected_safe_url).to eq(service.call(non_ascii_url)) }
end

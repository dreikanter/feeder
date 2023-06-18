require "rails_helper"

RSpec.describe Hackernews do
  subject(:service) { described_class }

  describe ".best_stories_url" do
    subject(:result) { service.best_stories_url }

    it { expect(result).to eq("https://hacker-news.firebaseio.com/v0/beststories.json") }
  end

  describe ".thread_url" do
    subject(:result) { service.thread_url("THREAD_ID") }

    it { expect(result).to eq("https://news.ycombinator.com/item?id=THREAD_ID") }
  end

  describe ".item_url" do
    subject(:result) { service.item_url("ITEM_ID") }

    it { expect(result).to eq("https://hacker-news.firebaseio.com/v0/item/ITEM_ID.json") }
  end
end

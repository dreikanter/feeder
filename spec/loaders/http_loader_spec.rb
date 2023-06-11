require 'rails_helper'

RSpec.describe HttpLoader do
  subject(:loader) { described_class }

  let(:feed) { build(:feed) }
  let(:content) { 'BANANA' }
  let(:arbitrary_error) { 'arbitrary error object' }

  it 'requires feed url to present' do
    feed.url = nil
    expect { loader.call(feed) }.to raise_error(HTTP::Error)
  end

  it 'requires explicit scheme' do
    feed.url = URI.parse(feed.url).tap { |parsed| parsed.scheme = nil }.to_s
    expect { loader.call(feed) }.to raise_error(HTTP::Error)
  end

  it 'returns successful response body' do
    stub_request(:get, feed.url).to_return(body: content)
    expect(loader.call(feed)).to eq(content)
  end

  it 'raises on error response' do
    stub_request(:get, feed.url).to_return(status: 404)
    expect { loader.call(feed) }.to raise_error(BaseLoader::Error)
  end

  it 'passes request execution errors' do
    stub_request(:get, feed.url).to_raise(arbitrary_error)
    expect { loader.call(feed) }.to raise_error(arbitrary_error)
  end
end

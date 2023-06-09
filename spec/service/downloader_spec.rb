require 'rails_helper'

RSpec.describe Downloader do
  subject(:service) { Downloader }

  let(:url) { 'https://placehold.it/1x1.png' }
  let(:expected_content_type) { 'image/png' }

  let(:expected_io) do
    StringIO.new(binary_image_data.read).tap do |io|
      # Otherwise it would be UTF-8
      io.set_encoding(Encoding::BINARY)
    end
  end

  let(:binary_image_data) { file_fixture('1x1.png') }
  let(:non_ascii_url) { 'https://www.reddit.com/r/worldnews/comments/11yg2e7/germany_shots_fired_at_police_in_reichsbürger/' }

  before do
    [url, non_ascii_url].each do |image_url|
      stub_request(:get, image_url)
        .to_return(
          headers: { 'Content-Type' => expected_content_type },
          body: binary_image_data
        )
    end
  end

  it 'should download stuff' do
    service.call(url) do |io, content_type|
      expect(expected_io.read).to eq(io.read)
      expect(expected_content_type).to eq(content_type)
    end
  end

  it 'should accept non-ascii urls' do
    service.call(url) do |io, content_type|
      expect(expected_io.read).to eq(io.read)
      expect(expected_content_type).to eq(content_type)
    end
  end
end

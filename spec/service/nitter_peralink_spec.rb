require "rails_helper"

RSpec.describe NitterPermalink do
  subject(:service) { described_class }

  it 'returns https links' do
    result = service.call('http://example.com/nathanwpyle/status/1098710518058176512')
    expect(result).to eq('https://twitter.com/nathanwpyle/status/1098710518058176512')
  end

  it 'tolerates anchors and GET params' do
    result = service.call('https://example.com/nathanwpyle/status/1098710518058176512?s=20#banana')
    expect(result).to eq('https://twitter.com/nathanwpyle/status/1098710518058176512?s=20#banana')
  end
end

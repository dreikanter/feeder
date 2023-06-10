require 'rails_helper'

RSpec.describe NitterInstancesFetcher do
  subject(:service) { described_class }

  let(:content) { file_fixture('nitter_instances_wiki_page.html').read }
  let(:expected) { JSON.parse(file_fixture('nitter_instances_wiki_page.json').read) }

  def test_fetches_expected_urls
    stub_request(:get, service::PUBLIC_INSTANCES_WIKI_PAGE_URL).to_return(body: content)
    expect(service.call).to contain_exactly(expected)
  end
end

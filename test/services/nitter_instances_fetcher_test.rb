require 'test_helper'

class NitterInstancesFetcherTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:subject) { NitterInstancesFetcher }
  let(:content) { file_fixture('nitter_instances_wiki_page.html').read }
  let(:expected) { JSON.parse(file_fixture('nitter_instances_wiki_page.json').read) }

  def test_fetches_expected_urls
    stub_request(:get, subject::PUBLIC_INSTANCES_WIKI_PAGE_URL).to_return(body: content)
    assert_equal expected.sort, subject.call.sort
  end
end

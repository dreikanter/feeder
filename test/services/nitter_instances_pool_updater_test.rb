require "test_helper"

class NitterInstancesPoolUpdaterTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:subject) { NitterInstancesPoolUpdater }
  let(:content) { file_fixture("nitter_instances_wiki_page.html").read }
  let(:expected) { JSON.parse(file_fixture("nitter_instances_wiki_page.json").read) }

  def setup
    stub_request(:get, NitterInstancesFetcher::PUBLIC_INSTANCES_WIKI_PAGE_URL).to_return(body: content)
  end

  def test_should_import_instances
    subject.call
    imported_urls = NitterInstance.where(status: :enabled).pluck(:url)
    assert_equal expected.sort, imported_urls.sort
  end

  def test_should_be_idempotent
    subject.call

    assert_no_changes -> { NitterInstance.pluck(:id, :url, :status) } do
      subject.call
    end
  end
end

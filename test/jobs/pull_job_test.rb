require 'test_helper'

class PullJobTest < Minitest::Test
  def subject
    PullJob
  end

  def feed
    build(:feed)
  end

  def test_call_import_service
    Import.stubs(:call)
    Import.expects(:call)
    subject.perform_now(feed)
  end
end

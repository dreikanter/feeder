require 'rails_helper'

RSpec.describe NitterInstance do
  subject(:nitter_instance) { create(:nitter_instance) }

  it 'defines initial state' do
    assert nitter_instance.enabled?
  end

  it 'updates errored at' do
    freeze_time do
      nitter_instance.error!
      assert_equal DateTime.now, nitter_instance.errored_at.to_datetime
    end
  end

  it 'counts errors' do
    2.times { nitter_instance.error! }
    assert_equal 2, nitter_instance.errors_count
  end

  it 'disables after max errors limit exceeded' do
    nitter_instance.update!(errors_count: NitterInstance::MAX_ERRORS.pred)
    nitter_instance.error!
    assert nitter_instance.disabled?
  end
end

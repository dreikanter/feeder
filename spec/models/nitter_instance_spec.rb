require 'rails_helper'

RSpec.describe NitterInstance do
  subject(:nitter_instance) { create(:nitter_instance) }

  it 'defines initial state' do
    expect(nitter_instance).to be_enabled
  end

  it 'updates errored at' do
    freeze_time do
      nitter_instance.error!
      expect(DateTime.now).to eq(nitter_instance.errored_at.to_datetime)
    end
  end

  it 'counts errors' do
    2.times { nitter_instance.error! }
    expect(nitter_instance.errors_count).to eq(2)
  end

  it 'disables after max errors limit exceeded' do
    nitter_instance.update!(errors_count: NitterInstance::MAX_ERRORS.pred)
    nitter_instance.error!
    expect(nitter_instance).to be_disabled
  end

  it 'calculates stats' do
    described_class.delete_all
    %w[enabled enabled errored].each { |state| create(:nitter_instance, status: state) }
    expect(described_class.stats).to eq('errored: 1; enabled: 2')
  end
end

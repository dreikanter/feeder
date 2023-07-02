require "rails_helper"

RSpec.describe ServiceInstance do
  subject(:model) { described_class }

  before { freeze_time }

  describe "validations" do
    let(:blank) { model.new(url: nil, service_type: nil) }

    before { blank.validate }

    it { expect(blank.errors).to include(:service_type) }
    it { expect(blank.errors).to include(:url) }
  end

  describe "state" do
    it { expect(model.new).to be_enabled }

    it { expect(permitted_transitions_from(:enabled)).to match_array(%i[failed suspended disabled]) }
    it { expect(permitted_transitions_from(:failed)).to match_array(%i[enabled failed suspended disabled]) }
    it { expect(permitted_transitions_from(:suspended)).to match_array(%i[enabled disabled]) }
    it { expect(permitted_transitions_from(:disabled)).to match_array(%i[enabled]) }

    def permitted_transitions_from(state)
      model.new(state: state).aasm.states(permitted: true).map(&:name)
    end
  end

  describe "#operational" do
    subject(:scope) { model.operational }

    let(:enabled_instance) { create(:service_instance, state: :enabled, used_at: 1.hour.ago) }
    let(:failed_instance) { create(:service_instance, state: :failed, used_at: 2.hour.ago) }
    let(:suspended_instance) { create(:service_instance, state: :suspended) }
    let(:disabled_instance) { create(:service_instance, state: :disabled) }

    before do
      enabled_instance
      failed_instance
      suspended_instance
      disabled_instance
    end

    it { expect(scope).to eq([failed_instance, enabled_instance]) }
  end
end

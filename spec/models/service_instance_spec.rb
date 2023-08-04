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

  describe ".least_used" do
    subject(:used_at_values) { model.least_used.pluck(:used_at) }

    let(:never_used_instance) { create(:service_instance, used_at: nil) }
    let(:recently_used_instance) { create(:service_instance, used_at: 1.second.ago) }
    let(:not_used_for_a_long_time_instance) { create(:service_instance, used_at: 2.days.ago) }

    before do
      model.delete_all

      not_used_for_a_long_time_instance
      recently_used_instance
      never_used_instance
    end

    it { expect(used_at_values).to eq([nil, 2.days.ago, 1.second.ago]) }
  end

  describe ".ordered_by_state" do
    subject(:ordered_state_values) { model.ordered_by_state.pluck(:state) }

    before do
      model.delete_all
      %w[disabled suspended failed enabled].each { create(:service_instance, state: _1) }
    end

    it { expect(ordered_state_values).to eq(%w[enabled failed suspended disabled]) }
  end

  describe ".operational" do
    subject(:scope) { model.operational }

    let(:enabled_instance) { create(:service_instance, state: :enabled, used_at: 1.hour.ago) }
    let(:unused_enabled_instance) { create(:service_instance, state: :enabled, used_at: nil) }
    let(:failed_instance) { create(:service_instance, state: :failed, used_at: 2.hours.ago) }
    let(:suspended_instance) { create(:service_instance, state: :suspended) }
    let(:disabled_instance) { create(:service_instance, state: :disabled) }

    before do
      model.delete_all

      enabled_instance
      unused_enabled_instance
      failed_instance
      suspended_instance
      disabled_instance
    end

    it { expect(scope).to eq([unused_enabled_instance, failed_instance, enabled_instance]) }
  end

  describe "#register_error" do
    let(:enabled_instance) { create(:service_instance, state: :enabled) }
    let(:disabled_instance) { create(:service_instance, state: :disabled) }

    it "fails when possible" do
      expect { enabled_instance.register_error }.to(change { enabled_instance.reload.state }.from("enabled").to("failed"))
    end

    it "not fails when impossible" do
      expect { disabled_instance.register_error }.not_to(change { disabled_instance.reload.state })
    end
  end
end

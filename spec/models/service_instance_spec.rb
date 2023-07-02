require "rails_helper"

RSpec.describe ServiceInstance do
  subject(:model) { described_class }

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
end

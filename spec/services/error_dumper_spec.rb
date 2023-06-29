require "rails_helper"

RSpec.describe ErrorDumper do
  subject(:service) { described_class }

  let(:target) { create(:feed) }

  it "creates a record" do
    expect { subject.call }.to change { Error.count }.by(1)
  end

  it "returns error object" do
    error = dump_sample_exception
    expect(error).to be_a(Error)
  end

  it "persists target reference" do
    error = subject.call(target: target)
    expect(error.target).to eq(target)
  end

  it "persists backtrace" do
    error = dump_sample_exception
    expect(error.backtrace).to be_a(Array)
  end

  def dump_sample_exception
    raise "sample exception"
  rescue StandardError
    subject.call(exception: $ERROR_INFO)
  end
end

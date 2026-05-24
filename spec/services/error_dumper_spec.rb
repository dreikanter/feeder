require "rails_helper"

RSpec.describe ErrorDumper do
  subject(:service) { described_class }

  let(:target) { create(:feed) }

  it "creates a record" do
    expect { service.call }.to change(Error, :count).by(1)
  end

  it "returns error object" do
    error = dump_sample_exception
    expect(error).to be_a(Error)
  end

  it "persists target reference" do
    error = service.call(target: target)
    expect(error.target).to eq(target)
  end

  it "persists backtrace" do
    error = dump_sample_exception
    expect(error.backtrace).to be_a(Array)
  end

  it "notifies Honeybadger by default" do
    expect(Honeybadger).to receive(:notify)
    service.call
  end

  it "does not notify Honeybadger when notify is false" do
    expect(Honeybadger).not_to receive(:notify)
    service.call(notify: false)
  end

  it "still persists the error when notify is false" do
    expect { service.call(notify: false) }.to change(Error, :count).by(1)
  end

  def dump_sample_exception
    raise "sample exception"
  rescue StandardError
    service.call(exception: $ERROR_INFO)
  end
end

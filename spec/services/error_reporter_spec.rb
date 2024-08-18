require "rails_helper"

RSpec.describe ErrorReporter do
  subject(:service) { described_class }

  describe ".report" do
    it "creates a record" do
      expect { report_an_error }.to change(ErrorReport, :count).by(1)
    end

    it "persists error details" do
      error = report_an_error
      error_report = ErrorReport.last

      expect(error_report).to have_attributes(
        error_class: "RuntimeError",
        category: "CATEGORY",
        message: "TEST ERROR MESSAGE",
        backtrace: error.backtrace,
        context: {}
      )

      expect(error.backtrace.first).to include("#{error_report.file_name}:#{error_report.line_number}")
    end

    it "persists context as JSON" do
      today = Date.today

      context = {
        "string" => "value",
        "integer" => 1,
        "date" => today
      }

      error_report = service.report(error: StandardError.new, category: "CATEGORY", context: context)
      expect(error_report.context).to eq(context.as_json)
    end

    it "persists target" do
      feed = create(:feed)
      error_report = service.report(error: StandardError.new, category: "CATEGORY", target: feed)

      expect(error_report.target).to eq(feed)
    end

    def report_an_error
      raise "TEST ERROR MESSAGE"
    rescue StandardError => e
      service.report(error: e, category: "CATEGORY")
      e
    end
  end
end

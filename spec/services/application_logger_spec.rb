require "rails_helper"

RSpec.describe ApplicationLogger do
  subject(:service) { described_class }

  let(:application_logger) { described_class.new(logger: mock_logger, colorize: true) }
  let(:mock_logger) { instance_double(Logger) }
  let(:message) { "MESSAGE" }

  shared_examples "logger method" do |logger_method, options|
    describe "##{logger_method}" do
      let(:parent_logger_method) { options[:parent_logger_method] }
      let(:color) { options[:color] }

      context "when given a message" do
        it "calls the parent logger method with formatted message" do
          formatted_message = "#{color}#{message}\e[0m"

          expect(mock_logger).to receive(parent_logger_method).with(formatted_message)

          application_logger.send(logger_method, message)
        end
      end

      context "when given a block" do
        it "calls the parent logger method with formatted block result" do
          formatted_message = "#{color}#{message}\e[0m"

          expect(mock_logger).to receive(parent_logger_method) do |&block|
            expect(block.call).to eq(formatted_message)
          end

          application_logger.send(logger_method) { message }
        end
      end

      context "when colorize is set to false" do
        let(:application_logger) { described_class.new(logger: mock_logger, colorize: false) }

        it "calls the parent logger method with unformatted message" do
          expect(mock_logger).to receive(parent_logger_method).with(message)

          application_logger.send(logger_method, message)
        end
      end
    end
  end

  include_examples "logger method", :debug, parent_logger_method: :debug, color: ApplicationLogger::WHITE
  include_examples "logger method", :info, parent_logger_method: :info, color: ApplicationLogger::BLUE
  include_examples "logger method", :warn, parent_logger_method: :warn, color: ApplicationLogger::YELLOW
  include_examples "logger method", :error, parent_logger_method: :error, color: ApplicationLogger::RED
  include_examples "logger method", :success, parent_logger_method: :info, color: ApplicationLogger::GREEN
end

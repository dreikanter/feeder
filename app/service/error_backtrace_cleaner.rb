module Service
  class ErrorBacktraceCleaner
    def self.clean(exception)
      cleaner.clean(exception.backtrace)
    end

    PATTERN = /\/lib\/ruby\/gems\/|bin\/rails/.freeze

    def self.cleaner
      @cleaner ||= ActiveSupport::BacktraceCleaner.new.tap do |bc|
        bc.add_filter { |line| line.gsub(Rails.root.to_s, '') }
        bc.add_silencer { |line| line =~ PATTERN }
      end
    end
  end
end

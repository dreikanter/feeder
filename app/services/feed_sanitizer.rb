class FeedSanitizer
  include Callee

  option(:name, type: Dry::Types["strict.string"])
  option(:after, type: Dry::Types["params.date_time"], optional: true)
  option(:import_limit, type: Dry::Types["strict.integer"], optional: true)
  option(:loader, type: Dry::Types["strict.string"], optional: true)
  option(:normalizer, type: Dry::Types["strict.string"], optional: true)
  option(:processor, type: Dry::Types["strict.string"], optional: true)
  option(:url, type: Dry::Types["strict.string"], optional: true)
  option(:disabling_reason, type: Dry::Types["strict.string"], optional: true)

  option(
    :options,
    type: Dry::Types["strict.hash"],
    optional: true,
    default: -> { {} }
  )

  option(
    :refresh_interval,
    type: Dry::Types["strict.integer"],
    optional: true
  )

  # @return [Hash] sanitized feed configuration attributes
  def call
    option_names
      .map { |target| [target, send(target)] }
      .filter { |_, value| value.present? }
      .to_h
  end

  private

  def option_names
    self.class.dry_initializer.options.map(&:target)
  end
end

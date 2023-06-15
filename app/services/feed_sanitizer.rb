class FeedSanitizer
  include Callee

  option(:name, type: Dry::Types["strict.string"])
  option(:after, type: Dry::Types["params.date_time"], optional: true)
  option(:import_limit, type: Dry::Types["strict.integer"], optional: true)
  option(:loader, type: Dry::Types["strict.string"], optional: true)
  option(:normalizer, type: Dry::Types["strict.string"], optional: true)
  option(:processor, type: Dry::Types["strict.string"], optional: true)
  option(:url, type: Dry::Types["strict.string"], optional: true)
  option(:source, type: Dry::Types["strict.string"], optional: true)
  option(:description, type: Dry::Types["strict.string"], optional: true)
  option(:disabling_reason, type: Dry::Types["strict.string"], optional: true)
  option(:options, type: Dry::Types["strict.hash"], optional: true, default: -> { {} })
  option(:refresh_interval, type: Dry::Types["strict.integer"], optional: true)
  option(:enabled, type: Dry::Types["params.bool"], optional: true, default: -> { true })

  # @return [Hash] sanitized feed configuration data
  def call
    {
      name: name,
      enabled: enabled,
      attributes: attributes
    }
  end

  private

  def attributes
    attribute_option_names.filter_map { |attribute| send(attribute).then { |value| [attribute, value] } }.to_h.compact
  end

  def attribute_option_names
    option_names.excluding(:name, :enabled)
  end

  def option_names
    self.class.dry_initializer.options.map(&:target)
  end
end

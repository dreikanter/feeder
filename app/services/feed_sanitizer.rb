class FeedSanitizer
  include Callee

  option(:name, type: Dry::Types['strict.string'])
  option(:after, type: Dry::Types['params.date_time'], optional: true)
  option(:import_limit, type: Dry::Types['strict.integer'], optional: true)
  option(:loader, type: Dry::Types['strict.string'], optional: true)
  option(:normalizer, type: Dry::Types['strict.string'], optional: true)
  option(:processor, type: Dry::Types['strict.string'], optional: true)
  option(:url, type: Dry::Types['strict.string'], optional: true)

  option(
    :options,
    type: Dry::Types['strict.hash'],
    optional: true,
    default: proc { {} }
  )

  option(
    :refresh_interval,
    type: Dry::Types['strict.integer'],
    optional: true,
    default: proc { 0 }
  )

  def call
    self.class.dry_initializer.public_attributes(self)
  end
end

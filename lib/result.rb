class Result
  extend Dry::Initializer

  option :success, type: ->(value) { !!value }, default: proc { false }
  option :payload, optional: true

  def success?
    success
  end

  def failure?
    !success
  end
end

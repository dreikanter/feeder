class ParamSanitizer
  include Callee

  param :value
  option :default, optional: false
  option :available, optional: false

  def call
    available.include?(value) ? value : default
  end
end

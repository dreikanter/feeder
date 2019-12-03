module Operations
  class Base
    include Callee
    include S11nHelpers

    option :user
    option :params
    option :request
    option :options, optional: true, default: -> { {} }
  end
end

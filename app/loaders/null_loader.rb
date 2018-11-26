module Loaders
  class NullLoader < Base
    def call
      nil
    end
  end
end

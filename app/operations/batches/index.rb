module Operations
  module Batches
    class Index < Operations::Base
      def call
        {
          json: {
            batches: batches
          }
        }
      end

      private

      def batches
        []
      end
    end
  end
end

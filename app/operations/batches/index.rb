module Operations
  module Batches
    class Index < Operations::Base
      # Amount of recent data points to show
      HISTORY_DEPTH = 20

      def call
        {
          json: {
            batches: batches
          }
        }
      end

      private

      def batches
        DataPoint.for('batch').limit(HISTORY_DEPTH)
      end
    end
  end
end

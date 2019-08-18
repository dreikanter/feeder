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
      DataPoint
        .recent
        .for('batch')
        .map { |dp| dp.details }
    end
  end
end

module API
  class BatchesController < APIController
    def index
      perform Batches::Index
    end
  end
end

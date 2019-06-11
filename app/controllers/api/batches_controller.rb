module API
  class BatchesController < APIController
    def index
      perform Operations::Batches::Index
    end
  end
end

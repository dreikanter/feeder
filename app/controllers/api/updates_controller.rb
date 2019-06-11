module API
  class UpdatesController < APIController
    def index
      perform Operations::Updates::Index
    end
  end
end

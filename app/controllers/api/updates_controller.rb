module API
  class UpdatesController < APIController
    def index
      perform Updates::Index
    end
  end
end

module API
  class FeedsController < APIController
    def show
      perform Operations::Feeds::Show
    end

    def index
      perform Operations::Feeds::Index
    end
  end
end

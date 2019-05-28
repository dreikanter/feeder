module API
  class FeedsController < Operations::APIController
    def show
      perform Operations::Feeds::API::Show
    end

    def index
      perform Operations::Feeds::API::Index
    end
  end
end

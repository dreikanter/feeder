module API
  class FeedsController < APIController
    def show
      perform Feeds::Show
    end

    def index
      perform Feeds::Index
    end
  end
end

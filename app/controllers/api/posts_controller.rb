module API
  class PostsController < APIController
    def index
      perform Operations::Posts::Index
    end
  end
end

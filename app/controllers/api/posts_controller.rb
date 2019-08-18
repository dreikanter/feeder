module API
  class PostsController < APIController
    def index
      perform Posts::Index
    end
  end
end

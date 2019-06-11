module API
  class ActivityController < APIController
    def show
      perform Operations::Activity::Show
    end
  end
end

module API
  class ActivityController < APIController
    def show
      perform Activity::Show
    end
  end
end

class StatsController < ApplicationController
  def show
    @feeds = Feed.all
  end
end

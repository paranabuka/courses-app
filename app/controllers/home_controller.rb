class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @popular_courses = Course.all.limit(3)
    @top_rated_courses = Course.all.limit(3)
    @most_recent_courses = Course.all.limit(3).order(created_at: :desc)
  end
end

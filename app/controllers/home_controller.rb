class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @enrolled_courses = Course.enrolled_by(current_user).most_recent_enrolled.limit(3) if current_user
    @popular_courses = Course.published.approved.popular.most_recent.limit(3)
    @top_rated_courses = Course.published.approved.top_rated.most_recent.limit(3)
    @most_recent_courses = Course.published.approved.most_recent.limit(3)
    @reviewed_enrollments = Enrollment.reviewed.top_rated.recently_updated.limit(3)
    @popular_tags = Tag.in_use.most_popular.limit(10)
  end

  def activities
    if current_user.has_role?(:admin)
      @pagy, @activities = pagy(PublicActivity::Activity.all.order(created_at: :desc), items: 20)
    else
      redirect_to root_path, alert: unauthorized_msg
    end
  end

  def analytics
    redirect_to root_path, alert: unauthorized_msg unless current_user.has_role?(:admin)
  end

  private

  def unauthorized_msg
    'You are not authorized to perform this action.'
  end
end

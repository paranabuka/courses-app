module ActivitiesHelper
  def activity_path(activity)
    case activity.trackable_type
    when Lesson.name
      lesson = activity.trackable
      [lesson.course, lesson]
    when Course.name
      activity.trackable
    end
  end
end

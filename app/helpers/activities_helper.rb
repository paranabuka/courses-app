module ActivitiesHelper
  def activity_path(activity)
    case activity.trackable_type
    when Course.name
      activity.trackable
    when Lesson.name
      lesson = activity.trackable
      [lesson.course, lesson]
    when Enrollment.name
      enrollment = activity.trackable
      enrollments_path(q: { course_title_cont: enrollment.course.title, user_email_cont: enrollment.user.email })
    when Comment.name
      comment = activity.trackable
      [comment.lesson.course, comment.lesson]
    end
  end
end

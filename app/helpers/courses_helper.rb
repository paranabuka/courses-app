module CoursesHelper
  def enroll_in(course)
    return check_price(course) unless current_user
    return view_analytics(course) if course.owned_by?(current_user)
    return keep_learning(course) if course.already_enrolled?(current_user)
    return proceed_to_payment(course) if course.price.positive?

    free_enrollment(course)
  end

  private

  def check_price(course)
    link_to 'Check price', course_path(course), class: 'btn btn-success btn-md'
  end

  def view_analytics(course)
    link_to 'You created this course. See analytics', course_path(course)
  end

  def keep_learning(course)
    link_to 'You already enrolled in this course. Keep learning', course_path(course)
  end

  def proceed_to_payment(course)
    link_to number_to_currency(course.price), new_course_enrollment_path(course), class: 'btn btn-success text-light'
  end

  def free_enrollment(course)
    link_to 'Free', new_course_enrollment_path(course), class: 'btn btn-success text-light'
  end
end

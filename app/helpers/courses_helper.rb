module CoursesHelper
  def enroll_in(course)
    return check_price(course) unless current_user
    return view_analytics(course) if course.owned_by?(current_user)
    return keep_learning(course) if course.already_enrolled?(current_user)
    return proceed_to_payment(course) if course.price.positive?

    free_enrollment(course)
  end

  def review(course)
    return unless current_user && course.already_enrolled?(current_user)

    enrollment = course.enrollments.find_by(user_id: current_user.id)

    return unless enrollment
    return add_review(enrollment) unless enrollment.rating.present?

    see_review(enrollment)
  end

  private

  def check_price(course)
    link_to 'Check price', new_course_enrollment_path(course), class: 'btn btn-success btn-md text-light'
  end

  def view_analytics(course)
    link_to 'You created this course. See analytics', course_path(course)
  end

  def keep_learning(course)
    link_to course_path(course) do
      "#{spinner_icon} #{number_to_percentage(course.progress(current_user), precision: 0)}".html_safe
    end
  end

  def proceed_to_payment(course)
    link_to number_to_currency(course.price), new_course_enrollment_path(course), class: 'btn btn-success text-light'
  end

  def free_enrollment(course)
    link_to 'Free', new_course_enrollment_path(course), class: 'btn btn-success text-light'
  end

  def add_review(enrollment)
    link_to edit_enrollment_path(enrollment) do
      "#{star_icon} Add review".html_safe
    end
  end

  def see_review(enrollment)
    link_to enrollment do
      "#{review_icon} Your review".html_safe
    end
  end

  def star_icon
    content_tag(:i, '', class: 'text-warning fa-solid fa-star')
  end

  # def rating_stars(rating)
  #   rating.times.map do
  #     star_icon
  #   end.join
  # end

  def review_icon
    content_tag(:i, '', class: 'fa-solid fa-comment')
  end

  def spinner_icon
    content_tag(:i, '', class: 'fa-solid fa-spinner')
  end
end

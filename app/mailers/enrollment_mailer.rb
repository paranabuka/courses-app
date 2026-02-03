class EnrollmentMailer < ApplicationMailer
  def new_enrollment(enrollment)
    @enrollment = enrollment
    @course = @enrollment.course
    mail(to: @enrollment.user.email, subject: "You have enrolled to: #{@course.title}")
  end

  def new_student(enrollment)
    @enrollment = enrollment
    @course = @enrollment.course
    mail(to: @course.user.email, subject: "You have a new student in: #{@course.title}")
  end
end

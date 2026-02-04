# Preview all emails at http://localhost:3000/rails/mailers/enrollment_mailer
class EnrollmentMailerPreview < ActionMailer::Preview
  def new_enrollment
    EnrollmentMailer.new_enrollment(Enrollment.last)
  end

  def new_student
    EnrollmentMailer.new_student(Enrollment.last)
  end
end

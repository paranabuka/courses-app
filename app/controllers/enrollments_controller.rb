class EnrollmentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:certificate]

  before_action :set_enrollment, only: %i[show edit update destroy certificate]
  before_action :set_course, only: %i[new create checkout_success]

  # GET /enrollments or /enrollments.json
  def index
    @ransack_path = enrollments_path
    @q = Enrollment.ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result.includes(:user, :course))
    authorize @enrollments
  end

  def students
    @ransack_path = students_enrollments_path
    @q = Enrollment.joins(:course).where(courses: { user_id: current_user.id }).ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result.includes(:user))
    render :index
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
  end

  def certificate
    authorize @enrollment, :certificate?
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@enrollment.course.title}, #{@enrollment.user.email}",
               page_size: 'A4',
               template: 'enrollments/certificate.pdf.erb'
      end
    end
  end

  # GET /enrollments/new
  def new
    if current_user && @course.already_enrolled?(current_user)
      redirect_to course_path(@course), notice: 'You have already enrolled in the course.'
    else
      @enrollment = Enrollment.new
    end
  end

  # GET /enrollments/1/edit
  def edit
    authorize @enrollment
  end

  # POST /enrollments or /enrollments.json
  def create
    if @course.price.positive?
      session = create_checkout_session(@course)
      redirect_to session.url, status: :see_other
    else
      checkout_success
    end
  end

  def checkout_success
    @enrollment = @current_user.enroll_in(@course)
    dispatch_mailers(@enrollment)
    redirect_to course_path(@course), notice: 'You have successfully enrolled in the course.'
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    authorize @enrollment
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to @enrollment, notice: 'Enrollment was successfully updated.' }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    authorize @enrollment
    @enrollment.destroy

    respond_to do |format|
      format.html { redirect_to enrollments_path, status: :see_other, notice: 'Enrollment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_enrollment
    @enrollment = Enrollment.friendly.find(params[:id])
  end

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def create_checkout_session(course)
    Stripe::Checkout::Session.create(
      {
        payment_method_types: ['card'],
        customer_email: current_user.email,
        line_items: [{
          quantity: 1,
          price_data: {
            product_data: { name: "Enrollment for #{course.title}" },
            unit_amount: course.price,
            currency: 'usd'
          }
        }],
        mode: 'payment',
        success_url: checkout_success_course_enrollments_url(course),
        cancel_url: new_course_enrollment_url(course)
      }
    )
  end

  def dispatch_mailers(enrollment)
    EnrollmentMailer.new_enrollment(enrollment).deliver_later
    EnrollmentMailer.new_student(enrollment).deliver_later
  end

  # Only allow a list of trusted parameters through.
  def enrollment_params
    params.require(:enrollment).permit(:rating, :review)
  end
end

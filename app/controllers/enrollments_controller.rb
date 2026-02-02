class EnrollmentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:certificate]

  before_action :set_enrollment, only: %i[show edit update destroy certificate]
  before_action :set_course, only: %i[new create]

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
    @enrollment = @current_user.enroll_in(@course)
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

  # Only allow a list of trusted parameters through.
  def enrollment_params
    params.require(:enrollment).permit(:rating, :review)
  end
end

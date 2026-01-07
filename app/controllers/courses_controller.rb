class CoursesController < ApplicationController
  before_action :set_course, only: %i[show edit update destroy approve reject]

  # GET /courses or /courses.json
  def index
    @ransack_path = courses_path
    @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
  end

  def my_enrolled
    @ransack_path = my_enrolled_courses_path
    @q = Course.joins(:enrollments).where(enrollments: { user_id: current_user.id })
    @ransack_courses = @q.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

  def pending_review
    @ransack_path = pending_review_courses_path
    @q = Course.joins(:enrollments).merge(Enrollment.pending_review.where(user_id: current_user.id))
    @ransack_courses = @q.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

  def my_created
    @ransack_path = my_created_courses_path
    @q = Course.where(user_id: current_user.id)
    @ransack_courses = @q.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

  # GET /courses/1 or /courses/1.json
  def show
    authorize @course
    @lessons = @course.lessons
    @recent_reviews = @course.enrollments.reviewed.top_rated.recently_updated.limit(3)
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
    authorize @course
  end

  def pending_approval
    @ransack_path = pending_approval_courses_path
    @q = Course.published.not_approved
    @ransack_courses = @q.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

  def approve
    authorize @course
    @course.update_attribute(:approved, true)
    redirect_to @course, notice: 'Course approved successfully.'
  end

  def reject
    authorize @course, :approve?
    @course.update_attribute(:approved, false)
    redirect_to @course, notice: 'Course rejected successfully.'
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    authorize @course
    @course.user = current_user

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    authorize @course
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    authorize @course
    if @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_path, status: :see_other, notice: 'Course was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to @course, alert: 'Course can not be destroyed since it has student(s).'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:title, :description, :short_description, :language, :level, :price, :published)
  end
end

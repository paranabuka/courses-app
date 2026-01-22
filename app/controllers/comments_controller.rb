class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]
  before_action :set_course_and_lesson, only: %i[new create destroy]

  def create
    @comment = Comment.new(comment_params)
    @comment.lesson_id = @lesson.id
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to course_lesson_path(@course, @lesson), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render 'lessons/comments/new', status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to course_lesson_path(@course, @lesson), notice: 'Comment was successfully destroyed.' }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_course_and_lesson
    @course = Course.friendly.find(params[:course_id])
    @lesson = Lesson.friendly.find(params[:lesson_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end

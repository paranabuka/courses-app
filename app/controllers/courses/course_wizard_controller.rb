class Courses::CourseWizardController < ApplicationController
  include Wicked::Wizard

  before_action :set_course, only: %i[show update finish_wizard_path]
  before_action :set_progress, only: %i[show update]

  steps :general_info, :details

  def show
    authorize @course, :edit?
    case step
    when :details
      preload_tags
    end
    render_wizard
  end

  def update
    authorize @course, :edit?
    case step
    when :general_info
      @course.update(course_params)
    when :details
      preload_tags
      @course.update(course_params)
    end
    render_wizard
  end

  def finish_wizard_path
    authorize @course, :edit?
    course_path(@course)
  end

  private

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def set_progress
    current_step = wizard_steps.index(step)

    @progress =
      if wizard_steps.any? && current_step.present?
        ((current_step + 1).to_d / wizard_steps.count) * 100
      else
        0
      end
  end

  def preload_tags
    @tags = Tag.all.in_use
  end

  def course_params
    params.require(:course).permit(:title, :description, :short_description, :language, :level, :price, :published,
                                   :cover, tag_ids: [])
  end
end

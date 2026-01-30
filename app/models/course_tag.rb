class CourseTag < ApplicationRecord
  belongs_to :course
  belongs_to :tag, counter_cache: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[course_id tag_id]
  end
end

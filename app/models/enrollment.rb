class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :user, :course, presence: true

  validates_uniqueness_of :user_id, scope: :course_id
  validates_uniqueness_of :course_id, scope: :user_id

  validate :user_cannot_be_course_owner

  def to_s
    "#{user} #{course}"
  end

  protected

  def user_cannot_be_course_owner
    return unless new_record? && user_id == course.user_id

    errors.add(:base, 'You can not enroll to your own course')
  end
end

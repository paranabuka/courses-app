class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :user, :course, presence: true

  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?

  validates_uniqueness_of :user_id, scope: :course_id
  validates_uniqueness_of :course_id, scope: :user_id

  validate :user_cannot_be_course_owner

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  scope :pending_review, -> { where(rating: [0, nil], review: ['', nil]) }

  def to_s
    "#{user} #{course}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[review rating]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user course]
  end

  protected

  def user_cannot_be_course_owner
    return unless new_record? && user_id == course.user_id

    errors.add(:base, 'You can not enroll to your own course')
  end
end

class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  belongs_to :user, counter_cache: true

  validates :user, :course, presence: true

  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?

  validates_uniqueness_of :user_id, scope: :course_id
  validates_uniqueness_of :course_id, scope: :user_id

  validate :user_cannot_be_course_owner

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  include PublicActivity::Model
  tracked owner: ->(controller, _model) { controller.current_user }

  scope :pending_review, -> { where(rating: [0, nil], review: ['', nil]) }
  scope :rated, -> { where.not(rating: [0, nil]) }
  scope :reviewed, -> { where.not(review: ['', nil]) }
  scope :top_rated, -> { order(rating: :desc) }
  scope :recently_updated, -> { order(updated_at: :desc) }

  def to_s
    course.to_s
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[review rating created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user course]
  end

  after_save do
    course.update_average_rating unless rating.nil? || rating.zero?
  end

  after_destroy do
    course.update_average_rating
    course.calculate_income
    user.calculate_balance
  end

  after_create do
    course.calculate_income
    user.calculate_balance
  end

  protected

  def user_cannot_be_course_owner
    return unless new_record? && user_id == course.user_id

    errors.add(:base, 'You can not enroll to your own course')
  end
end

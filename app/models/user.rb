class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  has_many :courses, dependent: :nullify
  has_many :enrollments, dependent: :nullify
  has_many :user_lessons, dependent: :nullify

  rolify

  extend FriendlyId
  friendly_id :email, use: :slugged

  after_create :assign_default_role

  validate :must_have_at_least_one_role, on: :update

  def to_s
    email
  end

  def username
    email.split('@').first
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id email]
  end

  def online?
    updated_at > 2.minutes.ago
  end

  def enroll_in(course)
    enrollments.create(course: course, price: course.price)
  end

  def view_lesson(lesson)
    return if lesson.course.owned_by?(self)

    user_lesson = user_lessons.where(lesson: lesson).first_or_create
    user_lesson.increment!(:impressions)
  end

  private

  def assign_default_role
    add_role(:student) if roles.blank?
  end

  def must_have_at_least_one_role
    errors.add(:roles, 'must have at least one role assigned') if roles.blank?
  end
end

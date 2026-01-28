class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable,
         :omniauthable, omniauth_providers: %i[google_oauth2 github facebook]

  has_many :courses, dependent: :nullify
  has_many :enrollments, dependent: :nullify
  has_many :user_lessons, dependent: :nullify
  has_many :comments, dependent: :nullify

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

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first ||
           User.create(email: data['email'], password: Devise.friendly_token[0, 20])

    user.name = access_token.info.name
    user.image = access_token.info.image
    user.provider = access_token.provider
    user.uid = access_token.uid
    user.token = access_token.credentials.token
    user.expires_at = access_token.credentials.expires_at
    user.expires = access_token.credentials.expires
    user.refresh_token = access_token.credentials.refresh_token

    user
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

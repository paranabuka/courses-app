class Course < ApplicationRecord
  belongs_to :user, counter_cache: true

  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons
  has_many :course_tags, dependent: :destroy
  has_many :tags, through: :course_tags

  has_one_attached :cover

  validates :title, presence: true, uniqueness: true, length: { minimum: 3, maximum: 60 }
  validates :short_description, presence: true, length: { minimum: 5, maximum: 300 }, on: :update
  validates :description, presence: true, length: { maximum: 3_000 }, on: :update
  validates :language, :level, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :cover, presence: true,
                    content_type: ['image/png', 'image/jpeg'],
                    size: { less_than: 200.kilobytes },
                    on: :update

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :description

  include PublicActivity::Model
  tracked owner: ->(controller, _model) { controller.current_user }

  scope :published, -> { where(published: true) }
  scope :approved, -> { where(approved: true) }
  scope :not_approved, -> { where(approved: false) }
  scope :popular, -> { order(enrollments_count: :desc) }
  scope :top_rated, -> { order(average_rating: :desc) }
  scope :most_recent, -> { order(created_at: :desc) }
  scope :enrolled_by, ->(user) { joins(:enrollments).where(enrollments: { user_id: user.id }) }
  scope :most_recent_enrolled, -> { order('enrollments.created_at DESC') }

  def to_s
    title
  end

  LANGUAGES = %w[English Portuguese Spanish French German].freeze
  def self.languages
    LANGUAGES.map { |lang| [lang, lang] }
  end

  LEVELS = %w[Beginner Intermediate Advanced].freeze
  def self.levels
    LEVELS.map { |level| [level, level] }
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[title short_description language level price average_rating enrollments_count created_at tags_name_cont_any]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user course_tags tags]
  end

  def owned_by?(user)
    user.id == user_id
  end

  def already_enrolled?(user)
    enrollments.exists?(course_id: id, user_id: user.id)
  end

  def progress(user)
    return 0.0 if lessons_count.zero?

    user_lessons.where(user: user).count.to_f / lessons_count * 100.0
  end

  def update_average_rating
    if enrollments.rated.any?
      avg = enrollments.rated.average(:rating).to_f.round(2)
      update(average_rating: avg)
    else
      update(average_rating: 0)
    end
  end
end

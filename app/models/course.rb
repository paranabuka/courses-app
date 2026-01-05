class Course < ApplicationRecord
  validates :title, :short_description, :language, :level, :price, presence: true
  validates :description, presence: true, length: { minimum: 5 }

  belongs_to :user, counter_cache: true
  has_many :lessons, dependent: :destroy
  has_many :enrollments

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :description

  include PublicActivity::Model
  tracked owner: ->(controller, _model) { controller.current_user }

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
    %w[title short_description language level price]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user]
  end

  def owned_by?(user)
    user.id == user_id
  end

  def already_enrolled?(user)
    enrollments.exists?(course_id: id, user_id: user.id)
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

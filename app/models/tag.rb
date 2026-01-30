class Tag < ApplicationRecord
  has_many :course_tags
  has_many :courses, through: :course_tags

  validates :name, presence: true, length: { minimum: 3, maximum: 25 }, uniqueness: true

  scope :most_popular, -> { order(course_tags_count: :desc) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[course_tags courses]
  end
end

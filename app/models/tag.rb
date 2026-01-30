class Tag < ApplicationRecord
  has_many :course_tags
  has_many :courses, through: :course_tags

  validates :name, presence: true, length: { minimum: 3, maximum: 25 }, uniqueness: true
end

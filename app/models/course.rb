class Course < ApplicationRecord
  validates :title, :short_description, :language, :level, :price, presence: true
  validates :description, presence: true, length: { minimum: 5 }

  belongs_to :user

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :description

  def to_s
    title
  end

  LANGUAGES = %w[English Portuguese Spanish French German]
  def self.languages
    LANGUAGES.map { |lang| [lang, lang] }
  end

  LEVELS = %w[Beginner Intermediate Advanced]
  def self.levels
    LEVELS.map { |level| [level, level] }
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title short_description language level price]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end

class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true

  has_many :user_lessons, dependent: :destroy

  has_rich_text :content

  validates :title, presence: true, length: { maximum: 60 }
  validates_uniqueness_of :title, scope: :course_id
  validates :content, :course, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: ->(controller, _model) { controller.current_user }

  include RankedModel
  ranks :row_order, with_same: :course_id

  def to_s
    title
  end

  def completed_by?(user)
    user_lessons.where(user: user).exists?
  end

  def previous
    course.lessons.where('row_order < ?', row_order).order(row_order: :desc).limit(1).first
  end

  def next
    course.lessons.where('row_order > ?', row_order).order(row_order: :asc).limit(1).first
  end
end

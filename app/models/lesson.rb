class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true

  has_many :user_lessons, dependent: :destroy

  validates :title, :content, :course, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :content

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
end

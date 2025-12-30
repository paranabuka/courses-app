class Lesson < ApplicationRecord
  belongs_to :course

  validates :title, :content, :course, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :content

  include PublicActivity::Model
  tracked owner: ->(controller, _model) { controller.current_user }

  def to_s
    title
  end
end

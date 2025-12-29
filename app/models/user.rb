class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  has_many :courses

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
    %w[email]
  end

  def online?
    updated_at > 2.minutes.ago
  end

  private

  def assign_default_role
    add_role(:student) if roles.blank?
  end

  def must_have_at_least_one_role
    errors.add(:roles, 'must have at least one role assigned') if roles.blank?
  end
end

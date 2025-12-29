class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  has_many :courses

  after_create :assign_default_role

  def to_s
    email
  end

  def username
    email.split('@').first
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[email]
  end

  def assign_default_role
    self.add_role(:student) if self.roles.blank?
  end
end

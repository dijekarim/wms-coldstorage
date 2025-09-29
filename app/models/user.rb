class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  enum :role, { admin: 0, manager: 1, viewer: 2 }, default: 2

  validates :role, presence: true
end

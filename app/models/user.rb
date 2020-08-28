class User < ApplicationRecord
  validates :email, uniqueness: true
  validates_format_of :email, with: /@/
  validates :password_digest, presence: true

  has_secure_password

  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
end

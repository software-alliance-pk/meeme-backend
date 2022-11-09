class User < ApplicationRecord
  scope :by_recently_created, -> (limit) { order(created_at: :desc).limit(limit) }

  has_secure_password
  # mount_uploader :avatar, AvatarUploader
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
  has_many :verification_tokens, dependent: :destroy
  has_one_attached :profile_image, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments ,dependent: :destroy
  has_many :likes,dependent: :destroy
end

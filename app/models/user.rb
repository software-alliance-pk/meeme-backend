class User < ApplicationRecord
  after_create :create_wallet
  scope :recently_created, -> (limit) { order(created_at: :desc) }

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
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :tournament_users
  has_many :tournament_banners, through: :tournament_users
  has_many :followers, dependent: :destroy
  has_many :stories,dependent: :destroy
  has_one :wallet,dependent: :destroy

  def create_wallet
    @@user_wallet=Wallet.new(user_id: self.id)
    @@user_wallet.save
  end
end

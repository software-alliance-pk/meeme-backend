class User < ApplicationRecord
  scope :recently_created, -> (limit) { order(created_at: :desc) }
  enum push_notifications: { enabled: 0,
                             disabled: 1 }, _prefix: :notifications

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
  has_one :wallet, dependent: :destroy
  has_many :user_cards, dependent: :destroy
  has_many :transactions,dependent: :destroy
  belongs_to :user_store,optional: true
  # has_many :messages
  # has_many :messages_as_sender, foreign_key: "sender_id", class_name: "Message"
  has_many :mobile_devices, dependent: :destroy
  has_many :notifications, dependent: :destroy


  def get_wallet
    return self.wallet if self.wallet.present?
    tmp_wallet = Wallet.new(user_id: id)
    tmp_wallet.save
    tmp_wallet
  end

  def pending_friend_request
    Follower.where(status: "pending", follower_user_id: self.id)
  end

  def self.search(search)
    where("username LIKE ?", "%#{search}%")
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end

end

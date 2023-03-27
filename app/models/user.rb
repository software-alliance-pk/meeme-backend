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
  has_many :followings,class_name: "Follower",foreign_key: :follower_user_id
  has_many :stories,dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_many :user_cards, dependent: :destroy
  has_many :transactions,dependent: :destroy
  belongs_to :user_store,optional: true, dependent: :destroy
  has_many :user_badges, dependent: :destroy
  has_many :badges,through: :user_badges, dependent: :destroy
  has_many :mobile_devices, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :block_users, dependent: :destroy
  has_many :blocked_users, :foreign_key => "user_id", :class_name => "BlockUser"

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
    if "enable".include?(search.downcase)
      where(disabled: false)
    elsif 'disable'.include?(search.downcase)
      where(disabled: true)
    elsif search.downcase == 'active'
      where(status: true)
    elsif search.downcase == 'inactive'
      where(status: false)
    else
      where("lower(username) || lower(email) LIKE ?", "%#{search.downcase}%")
    end
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

class Message < ApplicationRecord
  scope :recently_created, -> { order(created_at: :desc) }
  belongs_to :conversation, dependent: :destroy
  # belongs_to :user, class_name:  'User',optional: true
  belongs_to :receiver, class_name: 'User', optional: true
  belongs_to :admin_user, class_name: 'AdminUser', optional: true
  belongs_to :sender, class_name: 'User', optional: true
  has_one_attached :message_image, dependent: :destroy
  enum subject: [:nothing_happened, :abuse, :payment, :image, :profile, :tournament_winner, :coins, :plagarism, :winner_feedback]

  # after_create_commit { MessageBroadCastJob.perform_later(self) }
end

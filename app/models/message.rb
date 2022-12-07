class Message < ApplicationRecord
  scope :recently_created, -> { order(created_at: :desc) }
  belongs_to :conversation
  # belongs_to :user, class_name:  'User',optional: true
  belongs_to :receiver, class_name: 'User', optional: true
  belongs_to :sender, class_name: 'User', optional: true
  has_one_attached :message_image, dependent: :destroy
  after_create_commit { MessageBroadCastJob.perform_later(self) }
end

class Message < ApplicationRecord
  scope :recently_created, -> { order(created_at: :desc) }
  belongs_to :conversation, dependent: :destroy
  # belongs_to :user, class_name:  'User',optional: true
  belongs_to :receiver, class_name: 'User', optional: true
  belongs_to :admin_user, class_name: 'AdminUser', optional: true
  belongs_to :sender, class_name: 'User', optional: true
  has_many_attached :message_images, dependent: :destroy
  enum subject: [:Nothing_Happened, :Abuse, :Payment, :Image, :Profile, :Tournament_Winner, :Coins, :Plagiarism, :Winner_Feedback]

end

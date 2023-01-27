class Message < ApplicationRecord
  after_commit :upload_image
  after_commit :notification_update
  scope :recently_created, -> { order(created_at: :desc) }
  belongs_to :conversation, dependent: :destroy
  # belongs_to :user, class_name:  'User',optional: true
  belongs_to :receiver, class_name: 'User', optional: true
  belongs_to :admin_user, class_name: 'AdminUser', optional: true
  belongs_to :sender, class_name: 'User', optional: true
  has_many_attached :message_images, dependent: :destroy
  enum subject: [:Nothing_Happened, :Abuse, :Payment, :Image, :Profile, :Tournament_Winner, :Coins, :Plagiarism, :Winner_Feedback]

  def notification_update
    broadcast_render_to "notifications", partial: "dashboard/notifications", formats: [:html]
  end
  def upload_image
    broadcast_render_to "divs", partial: "dashboard/message", formats: [:html] ,locals: { role: self, user: Current.admin_user }
  end

end

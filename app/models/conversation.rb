class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :user, class_name: 'User', optional: true
  belongs_to :receiver, class_name: 'User', optional: true
  belongs_to :sender, class_name: 'User', optional: true
  belongs_to :admin_user, class_name: 'AdminUser', optional: true
  before_destroy :destroy_associated_messages

  enum status: ['Nothing', 'Ongoing', 'Closed']

  private

  def destroy_associated_messages
    self.messages.destroy_all
  end
end

class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :user, class_name:  'Conversation',optional: true
  belongs_to :receiver, class_name: 'User', optional: true
  belongs_to :sender, class_name: 'User', optional: true
  belongs_to :admin_user, class_name: 'AdminUser', optional: true
  enum status: ['Nothing','Ongoing','Closed']

end

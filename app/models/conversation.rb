class Conversation < ApplicationRecord
  has_many :messages
  belongs_to :user, class_name:  'Conversation',optional: true
  belongs_to :receiver, class_name: 'User', optional: true
  belongs_to :sender, class_name: 'User', optional: true
end

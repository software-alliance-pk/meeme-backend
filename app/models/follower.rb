class Follower< ApplicationRecord
  belongs_to :user, optional: true
  enum status: [:nothing,:pending,:added, :un_followed]
end
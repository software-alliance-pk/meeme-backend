class Follower< ApplicationRecord
  belongs_to :user, optional: true
  enum status: [:nothing,:pending,:follower_added, :following_added,:un_followed]

  after_create_commit  { FollowerBadgeJob.perform_now(self) }
  after_update  { FollowerBadgeJob.perform_now(self) }

end

class Story < ApplicationRecord
  belongs_to :user
  scope :recently_created, -> { order(created_at: :desc) }
end
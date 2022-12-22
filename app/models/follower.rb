class Follower< ApplicationRecord
  belongs_to :user, optional: true
  enum status: [:nothing,:pending,:added, :un_followed]

  after_create_commit  { FollowerBadgeJob.perform_now(self) }
  after_update  { FollowerBadgeJob.perform_now(self) }

end
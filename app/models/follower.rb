class Follower< ApplicationRecord
  belongs_to :user, optional: true
  enum status: [:nothing,:pending,:follower_added, :following_added,:un_followed]

  after_create_commit :run_follower_and_following_jobs
  after_update :run_follower_and_following_jobs

  def run_follower_and_following_jobs
    FollowerBadgeJob.perform_now(self)
    FollowingBadgeJob.perform_now(self)
  end

end

class Story < ApplicationRecord
  belongs_to :user
  scope :recently_created, -> { order(created_at: :desc) }
end
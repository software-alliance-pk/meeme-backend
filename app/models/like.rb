class Like <ApplicationRecord
  belongs_to :post,optional: true
  belongs_to :comment ,optional: true
  belongs_to :story ,optional: true
  belongs_to :tournament_banner ,optional: true
  belongs_to :user
  enum :status, [ :nothing_happened, :like, :dislike ]
  after_create_commit  { LikeBadgeJob.perform_now(self) }
  after_create_commit  { StreakBadgeJob.perform_now(self) }
  
end
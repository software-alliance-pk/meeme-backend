class UserStore < ApplicationRecord
  has_many :users
  after_create_commit { UserStoreJob.perform_now(self) }

end

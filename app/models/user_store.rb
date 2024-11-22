class UserStore < ApplicationRecord
  has_many :users
  after_create_commit { UserStoreJob.perform_now(self) }
  belongs_to :theme, optional: true
end

class Transaction < ApplicationRecord
  belongs_to :user

  def self.search(search)
    self.joins(:user).where("transactions.user_id = users.id AND users.username LIKE ?", "%#{search}%")
  end
end

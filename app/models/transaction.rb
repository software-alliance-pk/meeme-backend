class Transaction < ApplicationRecord
  belongs_to :user

  def self.search(search)
    if search.match('^[0-9]*$')
      self.joins(:user).where(amount: search)
    else
      self.joins(:user).where("transactions.user_id = users.id AND LOWER(users.username) || lower(users.email) || lower(transactions.brand) LIKE ?", "%#{search.downcase}%")
    end
  end

  def self.date_filter(start_date, end_date)
    Transaction.where("Date(created_at) >= (?) AND Date(created_at) <= (?)", start_date.to_date, end_date.to_date)
  end

  def self.start_date_filter(start_date)
    Transaction.where("DATE(created_at) >= (?)", start_date.to_date)
  end

  def self.end_date_filter(end_date)
    Transaction.where("DATE(created_at) = (?)", end_date.to_date)
  end
end

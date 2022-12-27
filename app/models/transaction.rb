class Transaction < ApplicationRecord
  belongs_to :user

  def self.search(search)
    self.joins(:user).where("transactions.user_id = users.id AND users.username LIKE ?", "%#{search}%")
  end

  def self.date_filter(start_date, end_date)
    Transaction.where(:created_at => start_date...end_date)
  end

  def self.start_date_filter(start_date)
    Transaction.where("created_at >= (?)", start_date)
  end
  
  def self.end_date_filter(end_date)
    Transaction.where("created_at.strftime(%F)".eql?(end_date))
  end
end

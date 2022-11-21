class Post < ApplicationRecord
  scope :by_recently_created, -> (limit) { order(created_at: :desc).limit(limit) }

  validates :description, presence:true

  belongs_to :user
  has_one_attached :post_image ,dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :tournament_banner,optional: true

  acts_as_taggable_on :tags

  def period_count_array
    from = self.created_at.beginning_of_day.beginning_of_day
    to = Date.today.end_of_day
    self.where(created_at: from..to).group('date(created_at)').count
  end

end

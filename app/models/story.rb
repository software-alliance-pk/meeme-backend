class Story < ApplicationRecord
  scope :recently_created, -> { order(created_at: :desc) }
  has_one_attached :story_image, dependent: :destroy
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def self.delete_after_24_hours
    @stories=Story.where("DATE(created_at) = ?", Date.today-1)
    @stories.destroy_all
    puts "Stories after 24 hours have been deleted successfully "
  end

  def self.deleted_story
    @stories=Story.last.destroy
    puts "Latest Story destroyed "
  end
end
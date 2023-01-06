class Story < ApplicationRecord
  scope :recently_created, -> { order(created_at: :desc) }
  has_one_attached :story_image, dependent: :destroy
  after_create :destroy_the_story_after_24_hrs

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def destroy_the_story_after_24_hrs
    job_will_run_at =  self.created_at + 24.hours
    Delayed::Job.enqueue(DeleteStoryJob.new(self.id),{run_at: job_will_run_at})
  end
end
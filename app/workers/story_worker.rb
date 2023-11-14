class StoryWorker
  include Sidekiq::Worker
  # @queue= :deleting_queue
  def perform(*args, story_id)
    Story.find(story_id).destroy
    puts "Hii"
  end
end
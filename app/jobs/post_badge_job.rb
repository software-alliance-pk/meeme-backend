class PostBadgeJob < ApplicationJob
  queue_as :default
  def perform(message)
    if message.user.posts.count == 10000
      @badge = Badge.find_by(title: "Mega Mileage badge")
      @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
      puts "Congratulations #{message.user.username} . You have been awarded #{@badge}"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
    elsif message.user.posts.count == 1000
      @badge = Badge.where(title: "Thousand Miles badges")
      @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
      puts "Congratulations #{message.user.username} . You have been awarded #{@badge}"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
    end
  end
end
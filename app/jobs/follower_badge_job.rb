class FollowerBadgeJob < ApplicationJob
  queue_as :default

  def perform(message)
    if message.user.followers.added.count == 100000
      @badge = Badge.find_by(title: "I Love My Community Badge")
      @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
      puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
    elsif message.user.followers.added.count == 5000
      @badge = Badge.find_by(title: "The Part Of The Part of Crowd Badge")
      @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
      puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
    elsif message.user.followers.added.count == 100
      @badge = Badge.find_by(title: "Follower Badge")
      @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
      puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
    elsif message.user.followers.pending.count == 100000
      @badge = Badge.find_by(title: "Influencer Badge")
      @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
      puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
    elsif message.user.followers.pending.count == 5000
      @badge = Badge.find_by(title: "Well Known Badge")
      @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
      puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
    elsif message.user.followers.pending.count == 100
      @badge = Badge.find_by(title: "Famous Badge")
      @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
      puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
    end
  end
end
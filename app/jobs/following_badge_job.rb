class FollowingBadgeJob < ApplicationJob
  queue_as :default

  def perform(message)
    current_user = User.find_by(id: message.follower_user_id)
    if current_user.followings.following_added.count == 20
      @badge = Badge.find_by(title: "Follower Bronze")
      @check = UserBadge.find_by(user_id: current_user.id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: current_user.id, badge_id: @badge.id)
        puts "Congratulations #{current_user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif current_user.followings.following_added.count == 5000
      @badge = Badge.find_by(title: "Follower Silver")
      @check = UserBadge.find_by(user_id: current_user.id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: current_user.id, badge_id: @badge.id)
        puts "Congratulations #{current_user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif current_user.followings.following_added.count == 100000
      @badge = Badge.find_by(title: "Follower Gold")
      @check = UserBadge.find_by(user_id: current_user.id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: current_user.id, badge_id: @badge.id)
        puts "Congratulations #{current_user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    end 
  end
end
class FollowerBadgeJob < ApplicationJob
  queue_as :default

  def perform(message)
    current_user = User.find_by(id: message.follower_user_id)
    if message.user.followers.added.count == 100000
      @badge = Badge.find_by(title: "I Love My Community Badge")
      @check = UserBadge.find_by(user_id: message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif message.user.followers.added.count == 5000
      @badge = Badge.find_by(title: "The Part Of The Part of Crowd Badge")
      @check = UserBadge.find_by(user_id: message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif message.user.followers.added.count == 100
      @badge = Badge.find_by(title: "Follower Badge")
      @check = UserBadge.find_by(user_id: message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif message.user.followers.pending.count == 100000
      @badge = Badge.find_by(title: "Influencer Badge")
      @check = UserBadge.find_by(user_id: message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif message.user.followers.pending.count == 5000
      @badge = Badge.find_by(title: "Well Known Badge")
      @check = UserBadge.find_by(user_id: message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif message.user.followers.pending.count == 100
      @badge = Badge.find_by(title: "Famous Badge")
      @check = UserBadge.find_by(user_id: message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    end
      if current_user.followers.added.count == 100000
      @badge = Badge.find_by(title: "I Love My Community Badge")
      @check = UserBadge.find_by(user_id: current_user.id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: current_user.id, badge_id: @badge.id)
        puts "Congratulations #{current_user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif current_user.followers.added.count == 5000
      @badge = Badge.find_by(title: "The Part Of The Part of Crowd Badge")
      @check = UserBadge.find_by(user_id: current_user.id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: current_user.id, badge_id: @badge.id)
        puts "Congratulations #{current_user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif current_user.followers.added.count == 100
      @badge = Badge.find_by(title: "Follower Badge")
      @check = UserBadge.find_by(user_id: current_user.id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: current_user.id, badge_id: @badge.id)
        puts "Congratulations #{current_user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif current_user.followers.pending.count == 100000
      @badge = Badge.find_by(title: "Influencer Badge")
      @check = UserBadge.find_by(user_id: current_user.id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: current_user.id, badge_id: @badge.id)
        puts "Congratulations #{current_user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif current_user.followers.pending.count == 5000
      @badge = Badge.find_by(title: "Well Known Badge")
      @check = UserBadge.find_by(user_id: current_user.id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: current_user.id, badge_id: @badge.id)
        puts "Congratulations #{current_user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif current_user.followers.pending.count == 100
      @badge = Badge.find_by(title: "Famous Badge")
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
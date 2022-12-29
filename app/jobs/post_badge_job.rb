class PostBadgeJob < ApplicationJob
  queue_as :default

  def perform(message)
    if message.user.posts.count == 10000
      @badge = Badge.find_by(title: "Mega Mileage Badge")
      @check = UserBadge.find(message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif message.user.posts.count == 1000
      @badge = Badge.find_by(title: "Thousand Miles Badges")
      @check = UserBadge.find(message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    end
    if message.user.posts.joins(:post_image_attachment).count == 100
      @badge = Badge.find_by(title: "Contributer Badge")
      @check = UserBadge.find(message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif message.user.posts.joins(:post_image_attachment).count == 500000
      @badge = Badge.find_by(title: "Factor Badge")
      @check = UserBadge.find(message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif message.user.posts.joins(:post_image_attachment).count == 10000000
      @badge = Badge.find_by(title: "Part Of The Family Badge")
      @check = UserBadge.find(message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    end
  end
end
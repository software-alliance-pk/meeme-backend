class UploadPhotoBadgeJob < ApplicationJob
    queue_as :default
  
    def perform(message)
      if message.user.posts.count == 100
        @badge = Badge.find_by(title: "Upload Photo Silver")
        @check = UserBadge.find_by(user_id: message.user_id, badge_id: @badge.id)
        if @check.present?
        else
          @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
          puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        end
      elsif message.user.posts.count == 500000
        @badge = Badge.find_by(title: "Upload Photo Gold")
        @check = UserBadge.find_by(user_id: message.user_id, badge_id: @badge.id)
        if @check.present?
        else
          @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
          puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        end
      elsif message.user.posts.count == 1000000
        @badge = Badge.find_by(title: "Upload Photo Gold")
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
    end
end
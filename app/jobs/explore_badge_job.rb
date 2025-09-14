class ExploreBadgeJob < ApplicationJob
    queue_as :default
    def perform(current_user)
     countt = User.find_by(id: current_user.id)&.explored
      if User.find_by(id: current_user.id)&.explored == 6
        @badge = Badge.find_by(title: "Explore Guru Silver")
        @check = UserBadge.find_by(user_id: current_user.id, badge_id: @badge.id)
        if @check.present?
        else
          @awarded_badge = UserBadge.create!(user_id: current_user.id, badge_id: @badge.id)
          puts "Congratulations. You have been awarded #{@badge.title}"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        end
      elsif User.find_by(id: current_user.id)&.explored == 5000000
        @badge = Badge.find_by(title: "Explore Guru Bronze")
        @check = UserBadge.find_by(user_id: current_user.id, badge_id: @badge.id)
        if @check.present?
        else
          @awarded_badge = UserBadge.create!(user_id: current_user.id, badge_id: @badge.id)
          puts "Congratulations. You have been awarded #{@badge.title}"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        end
      elsif User.find_by(id: current_user.id)&.explored == 10000000
        @badge = Badge.find_by(title: "Explore Guru Gold")
        @check = UserBadge.find_by(user_id: current_user.id, badge_id: @badge.id)
        if @check.present?
        else
          @awarded_badge = UserBadge.create!(user_id: current_user.id, badge_id: @badge.id)
          puts "Congratulations. You have been awarded #{@badge.title}"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        end
      end
    end
  end
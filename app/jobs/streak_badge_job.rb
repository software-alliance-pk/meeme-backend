class StreakBadgeJob < ApplicationJob
  queue_as :default

  def perform(message)
    @result.include? false
    @result = []
    @today_date = Time.zone.now.end_of_day.to_datetime
    60.times do |num|
      status = Like.where(created_at: (@today_date - num).beginning_of_day..(@today_date - num).end_of_day, is_judged: true, user_id: 52).where.not(post_id: nil).present?
      @result << status
      case num
      when 7
        if @result.exclude? false
          @badge = Badge.find_by(title: "Judgment Level 1 Badge")
          @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
          puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        end
      when 30
        if @result.exclude? false
          @badge = Badge.find_by(title: "Judgment Level 2 Badge")
          @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
          puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        end
      when 30
        if @result.exclude? false
          @badge = Badge.find_by(title: "Judgment Level 3 Badge")
          @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
          puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
          puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        end
      else

      end
    end
  end
class CommentBadgeJob < ApplicationJob
  queue_as :default

  def perform(message)
    if message.user.comments.count == 1000000
      @badge = Badge.find_by(title: "Opinionated Master Badge")
      @check = UserBadge.find(message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif message.user.comments.count == 500000
      @badge = Badge.find_by(title: "Reaction Guru Badge")
      @check = UserBadge.find(message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{message.user.username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    elsif message.user.comments.count == 100
      @badge = Badge.find_by(title: "Commentator Badge")
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
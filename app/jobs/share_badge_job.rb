class ShareBadgeJob < ApplicationJob
  queue_as :default
  def perform(message,current_user)
    @badge = Badge.find_by(title: "Sharing Is Caring Badge")
    @check = UserBadge.find_by(user_id: current_user.id, badge_id: @badge.id)
    if @check.present?
      puts "#{User.find_by(id: current_user.id).username} has already been awarded #{@badge.title}"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
    else
      @awarded_badge = UserBadge.create!(user_id: current_user.id, badge_id: @badge.id)
      puts "Congratulations #{User.find_by(id: current_user.id).username} . You have been awarded #{@badge.title}"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
    end
  end
end
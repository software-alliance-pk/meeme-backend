class UserStoreJob < ApplicationJob
  queue_as :default

  def perform(message)
    if message.name == "Space-Theme"
      @badge = Badge.find_by(title: "Spaceship Badge")
      @check = UserBadge.find_by(user_id: message.user_id, badge_id: @badge.id)
      if @check.present?
      else
        @awarded_badge = UserBadge.create!(user_id: message.user_id, badge_id: @badge.id)
        puts "Congratulations #{User.find_by(id: message.user_id).username} . You have been awarded #{@badge.title}"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
        puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
    end
  end
end
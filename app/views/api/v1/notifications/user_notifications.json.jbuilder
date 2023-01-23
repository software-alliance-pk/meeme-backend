json.notifications_count @notifications.count
json.notifications @notifications.each do |notification|
  json.notification_date notification.first
  json.notification notification.last
end
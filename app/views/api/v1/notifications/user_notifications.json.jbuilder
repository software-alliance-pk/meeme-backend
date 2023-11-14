json.notifications_count @notifications.count
json.notifications @notifications.each do |notification|
  json.title notification.first
  json.data notification.last
end
set :output, "./log/cron.log"
every 24.hours do
  runner "Story.delete_after_24_hours"
end


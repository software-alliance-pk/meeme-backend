# whenever --update-crontab --set environment='development' set the environemnt
# whenever use to display schedule
#  whenever --update-crontab update cron tab
# crontab -r clean crontab


set :output, "./log/cron.log"
# every 1.minutes do
#   runner "Story.delete_after_24_hours"
# end

every 1.minutes do
  # runner "Story.deleted_story"
  rake "story_delete:story_check"

end



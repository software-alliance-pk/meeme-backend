# whenever --update-crontab --set environment='development' set the environemnt
# whenever use to display schedule
#  whenever --update-crontab update cron tab
# crontab -r clean crontab


set :env_path, '/home/ubuntu/.rbenv/shims/ruby'
# env :PATH, @env_path if @env_path.present?

set :output, "./log/cron.log"

every 1.minute do
  rake 'story_delete:story_check'
end



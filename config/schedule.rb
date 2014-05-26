set :output, "#{path}/log/cron.log"

every 1.minutes do
  rake "scrap"
end

every "0 0,3,6,9,12,15,18,21 * * *" do
  rake "triger_scrap"
end

every 1.days, at: '20:00' do
  rake "clear_scrapdb"
end

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
  
# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

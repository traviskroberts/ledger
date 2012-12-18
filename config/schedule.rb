# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

every :sunday, :at => '4am' do
  rake "log:clear"
end

every :day, :at => '2am' do
  rake "schedules:run"
end

# Learn more: http://github.com/javan/whenever

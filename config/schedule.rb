# Use this file to easily define all of your cron jobs.

every :sunday, :at => '2am' do
  rake "log:clear"
end

every :day, :at => '4am' do
  rake "recurring_transactions:process"
end

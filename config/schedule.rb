env :PATH, ENV['PATH']

set :output, "/var/www/ledger/shared/log/cron.log"

every :day, at: "1:00am" do
  rake "recurring_transactions:process"
end

every 1.minute do
  rake "sanity_check"
end

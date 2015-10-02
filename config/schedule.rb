env :PATH, ENV['PATH']

set :output, "/var/www/ledger/shared/log/cron.log"

every :day, at: "1:00am" do
  rake "recurring_transactions:process"
end

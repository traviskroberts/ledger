namespace :recurring_transactions do
  desc "Applies any recurring transactions."
  task :process => :environment do
    Account.all.each do |account|
      month = Date.today.strftime("%B")
      day = Date.today.strftime("%-d").to_i

      # conditions based on days in month
      if month == 'February' && day == 28 # don't worry about leap year (too hard)
        transactions = account.recurring_transactions.where('day > ?', 27)
      elsif %w(April June September November).include?(month) && day == 30 # months with 30 days
        transactions = account.recurring_transactions.where('day > ?', 29)
      else
        transactions = account.recurring_transactions.where('day = ?', day)
      end

      transactions.each do |transaction|
        amt = (transaction.classification == 'debit' ? "-" : "") + transaction.dollar_amount.to_s
        account.entries.create(:float_amount => amt, :description => transaction.description, :date => Date.today)
      end
    end
  end
end

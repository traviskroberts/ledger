namespace :db do
  desc "Populate the database with test data."
  task :populate => :environment do
    Account.destroy_all

    user = User.first

    account = Account.create({
      :name => "Checking Account",
      :initial_balance => '$1250.93'
    })
    user.accounts << account

    account = Account.create({
      :name => "Savings Account",
      :initial_balance => '$4937.03'
    })
    user.accounts << account

    Account.all.each do |acct|
      Entry.create({
        :account_id => acct.id,
        :float_amount => '-7.35',
        :description => 'Lunch',
        :date => 6.days.ago
      })

      Entry.create({
        :account_id => acct.id,
        :float_amount => '-2.49',
        :description => 'Coffee',
        :date => 4.days.ago
      })

      Entry.create({
        :account_id => acct.id,
        :float_amount => '-9.12',
        :description => 'Dinner',
        :date => 4.days.ago
      })
    end
  end
end

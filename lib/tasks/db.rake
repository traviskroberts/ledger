namespace :db do
  desc "Populate the database with fake data."
  task :populate => :environment do
    Account.destroy_all

    user = User.first
    acct = user.accounts.create!({
      :name => "Sample Account",
      :initial_balance => '13.69'
    })

    1000.times do |i|
      acct.entries.create!({
        :description => "Sample Transaction #{i+1}",
        :float_amount => '24.68'
      })
    end
  end

end

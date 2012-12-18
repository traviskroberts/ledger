class CreateScheduledTransactions < ActiveRecord::Migration
  def change
    create_table :scheduled_transactions do |t|
      t.integer :account_id
      t.integer :day
      t.integer :amount

      t.timestamps
    end
  end
end

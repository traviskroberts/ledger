class CreateRecurringTransactions < ActiveRecord::Migration
  def change
    create_table :recurring_transactions do |t|
      t.integer :account_id
      t.integer :day
      t.integer :amount
      t.string :classification
      t.string :description

      t.timestamps
    end
  end
end

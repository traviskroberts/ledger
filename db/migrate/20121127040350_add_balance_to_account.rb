class AddBalanceToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :balance, :integer, default: 0
  end
end

class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :account_id
      t.string :description
      t.string :classification
      t.integer :amount

      t.timestamps
    end
  end
end

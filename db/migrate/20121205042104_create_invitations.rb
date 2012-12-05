class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :account_id
      t.integer :user_id
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end

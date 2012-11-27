class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :perishable_token
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.datetime :last_request_at
      t.integer :login_count
      t.string :last_login_ip
      t.string :current_login_ip

      t.timestamps
    end
  end
end

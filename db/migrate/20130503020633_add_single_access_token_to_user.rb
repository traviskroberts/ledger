class AddSingleAccessTokenToUser < ActiveRecord::Migration
  def up
    add_column :users, :single_access_token, :string

    User.reset_column_information
    User.all.each { |u| u.reset_single_access_token! }

    change_column :users, :single_access_token, :string, :null => false
  end

  def down
    remove_column :users, :single_access_token
  end
end

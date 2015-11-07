# Add username attrube to Users model for use in chess games
class AddUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
  end
end

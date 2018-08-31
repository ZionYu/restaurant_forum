class AddOauth2ToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :google_uid, :string
    add_column :users, :google_token, :string
  end
end

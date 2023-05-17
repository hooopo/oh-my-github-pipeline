class AddAvatarUrl < ActiveRecord::Migration[7.0]
  def change
    add_column :curr_user, :avatar_url, :string
    add_column :users, :avatar_url, :string
  end
end

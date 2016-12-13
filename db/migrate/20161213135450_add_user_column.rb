class AddUserColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :display_name, :string
    add_column :users, :picture_url, :string
    add_column :users, :status_message, :string
  end
end

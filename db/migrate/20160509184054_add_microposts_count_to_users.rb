class AddMicropostsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :microposts_count, :integer
  end
end

class AddIndexToUsers < ActiveRecord::Migration
  def change
  	# page 293 rails tutorails explains about unique: true (here is at database level not model level)
    add_index :users, :email, unique: true
  end
end

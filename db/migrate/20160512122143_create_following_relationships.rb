class CreateFollowingRelationships < ActiveRecord::Migration
  def change
    create_table :following_relationships do |t|
      t.integer :followed_id
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :following_relationships, :followed_id
    add_index :following_relationships, [:user_id, :followed_id], unique: true
  end
end

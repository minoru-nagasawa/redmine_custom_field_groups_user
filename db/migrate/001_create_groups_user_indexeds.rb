class CreateGroupsUserIndexeds < ActiveRecord::Migration
  def change
    create_table :groups_user_indexeds do |t|
      t.integer "group_id", limit: 4, null: false
      t.integer "user_id",  limit: 4, null: false
    end
    add_index :groups_user_indexeds , ["group_id", "user_id"], name: "groups_users_ids", unique: true, using: :btree
  end
end

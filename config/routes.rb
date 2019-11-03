# This is the URL when edited user list in the group view.
get 'groups/:id/users/edit', :to => 'groups#edit', :id => /\d+/
post 'groups/:id/users/edit', :to => 'groups#edit_users', :id => /\d+/, :as => 'edit_group_users'

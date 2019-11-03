require_dependency 'redmine_custom_field_groups_user/custom_fields_helper_patch'
require_dependency 'redmine_custom_field_groups_user/groups_controller_patch'
require_dependency 'redmine_custom_field_groups_user/group_patch'
require_dependency 'redmine_custom_field_groups_user/user_patch'

Redmine::Plugin.register :redmine_custom_field_groups_user do
  name 'Redmine Custom Field User In Group plugin'
  author 'Minoru Nagasawa'
  description 'Add custom fields for each user in the group.'
  version '0.0.1'
  url 'https://github.com/minoru-nagasawa/redmine_custom_field_groups_user'
  author_url 'https://github.com/minoru-nagasawa'
end

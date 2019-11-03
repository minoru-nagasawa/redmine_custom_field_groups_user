# This is a class with an Id for GroupsUser.
# I defined this class because CustomField requires an ID.
class GroupsUserIndexed < ActiveRecord::Base
  include Redmine::SafeAttributes
  
  acts_as_customizable
  
  safe_attributes 'custom_field_values'
end

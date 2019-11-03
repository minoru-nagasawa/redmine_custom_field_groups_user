# When creating a CustomField, we need to create a class named base class name + 'CustomField'.
class GroupsUserIndexedCustomField < CustomField
  def type_name
    :label_groups_user_indexed
  end
end

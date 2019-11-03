# Overwrite method using CustomFieldsHelper::CUSTOM_FIELDS_TABS to add a item to custom field list.
module CustomFieldsHelperPatch
  ADD_CUSTOM_FIELDS_TABS = [{:name    => 'GroupsUserIndexedCustomField',
                             :partial => 'custom_fields/index', 
                             :label   => :label_groups_user_indexed}]

  def self.included(base)
    base.send(:include, InstanceMethods)
    
    base.class_eval do
      alias_method_chain :render_custom_fields_tabs, :addition_tabs
      alias_method_chain :custom_field_type_options, :addition_tabs
    end
  end

  module InstanceMethods
    def render_custom_fields_tabs_with_addition_tabs(types)
      tabs = (CustomFieldsHelper::CUSTOM_FIELDS_TABS + ADD_CUSTOM_FIELDS_TABS).select {|h| types.include?(h[:name]) }
      render_tabs tabs
    end
    
    def custom_field_type_options_with_addition_tabs
      (CustomFieldsHelper::CUSTOM_FIELDS_TABS + ADD_CUSTOM_FIELDS_TABS).map {|h| [l(h[:label]), h[:name]]}
    end
  end
end

CustomFieldsHelper.send(:include, CustomFieldsHelperPatch)

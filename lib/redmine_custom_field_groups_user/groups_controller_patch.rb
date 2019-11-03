# I patched the GroupsController because I want to add (and delete) custom fields when adding (and deleting) users to a group.
# I also wanted to change custom fields, so I added a new method. (edit_users)
module GroupsControllerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    
    base.class_eval do
      alias_method_chain :add_users,   :custom_field
      alias_method_chain :remove_user, :custom_field
    end
  end

  module InstanceMethods
    # New method for edit cusom firlds
    def edit_users
      # Create groups_user_indexed array
      params.permit!
      gus = []
      params[:groups_user_indexed].each{ |userId, value|
        gu = GroupsUserIndexed.where(group_id: params[:id], user_id: userId).first_or_create
        gu.safe_attributes = value
        gus << gu
      }
      
      # Valid custom fields
      gus.each { |gu|
        if !gu.valid?
          gu.errors.each do |attribute, message|
            @group.errors.add(attribute, message)
          end
        end
      }
      
      if !@group.errors.blank?
        respond_to do |format|
          format.html { render :action => "edit" }
          format.js
          format.api {
            render_api_errors "#{l(:label_user)} #{l('activerecord.errors.messages.invalid')}"
          }
        end
        return
      end
      
      # Save
      gus.each { |gu|
        gu.save
      }
      
      respond_to do |format|
        format.html { redirect_to edit_group_path(@group, :tab => 'users') }
        format.js
        format.api {
          render_api_ok
        }
      end
    end

    # Add user and custom fields
    def add_users_with_custom_field()
      @users = User.not_in_group(@group).where(:id => (params[:user_id] || params[:user_ids])).to_a
      
      # Valid custom fields
      # Custom fields are the same for all users, so check only one person
      params.permit!
      if @users.any?
        @groups_user_indexed = GroupsUserIndexed.where(group_id: params[:id], user_id: @users.first.id).first_or_create
        @groups_user_indexed.safe_attributes = params[:groups_user_indexed]
        if !@groups_user_indexed.valid?
          respond_to do |format|
            format.html { redirect_to edit_group_path(@group, :tab => 'users') }
            format.js   { render partial: "groups/new_users_form_error", status: 400  }
            format.api {
              render_api_errors "#{l(:label_user)} #{l('activerecord.errors.messages.invalid')}"
            }
          end
          return
        end
      end
      
      # save
      @group.users << @users
      @users.each { |user|
        @groups_user_indexed = GroupsUserIndexed.where(group_id: params[:id], user_id: user.id).first_or_create
        @groups_user_indexed.safe_attributes = params[:groups_user_indexed]
        @groups_user_indexed.save
      }
      
      respond_to do |format|
        format.html { redirect_to edit_group_path(@group, :tab => 'users') }
        format.js
        format.api {
          if @users.any?
            render_api_ok
          else
            render_api_errors "#{l(:label_user)} #{l('activerecord.errors.messages.invalid')}"
          end
        }
      end
    end
    
    # Remove user and custom fields
    def remove_user_with_custom_field()
      remove_user_without_custom_field
      GroupsUserIndexed.find_by_group_id_and_user_id(@group.id, params[:user_id]).try!(&:destroy)
    end
  end
end

GroupsController.send(:include, GroupsControllerPatch)

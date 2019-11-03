# I patched a User because I wanted to delete groups_user_indexeds when I deleted the user.
module UserPatch
  def self.included(base)
    base.has_many :groups_user_indexeds, :dependent => :destroy
  end
end

User.send(:include, UserPatch)

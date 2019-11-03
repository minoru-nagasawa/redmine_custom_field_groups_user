# I patched a Group because I wanted to delete groups_user_indexeds when I deleted the group.
module GroupPatch
  def self.included(base)
    base.has_many :groups_user_indexeds, :dependent => :destroy
  end
end

Group.send(:include, GroupPatch)

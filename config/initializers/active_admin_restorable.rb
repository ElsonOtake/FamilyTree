# frozen_string_literal: true

# Soft-delete support for ActiveAdmin resources whose model is `acts_as_paranoid`.
# Call `restorable!` inside an `ActiveAdmin.register` block to:
#   * make soft-deleted rows visible and findable (index, show, member actions),
#   * add "Active" (default) / "Deleted" / "All" scopes,
#   * add a PUT `:restore` member action.
# Render a per-row / show "Restore" link with `restore_admin_<resource>_path(record)`.
module ActiveAdminRestorable
  def restorable!
    # Base the whole resource on `with_deleted` so soft-deleted rows can be listed,
    # shown and found by the restore action; the default scope below keeps the
    # historic "active only" listing.
    controller do
      def scoped_collection
        end_of_association_chain.with_deleted
      end
    end

    scope 'Active', :without_deleted, default: true
    scope 'Deleted', :only_deleted
    scope 'All', :with_deleted

    member_action :restore, method: :put do
      # Recursive so a restored person/couple also brings back its soft-deleted
      # child links (the couples_people join is paranoid too). recovery_window
      # limits the cascade to links deleted *with* this record, so links the user
      # unlinked independently earlier are not resurrected.
      resource.restore(recursive: true, recovery_window: 10.seconds)
      # Fall back to the index (always routed); some resources have no show route.
      redirect_back_or_to collection_path, notice: I18n.t('active_admin.restored', default: 'Record restored.')
    end
  end
end

ActiveAdmin::ResourceDSL.include(ActiveAdminRestorable)

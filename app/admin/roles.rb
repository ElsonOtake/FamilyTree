ActiveAdmin.register Role do
  restorable!

  config.sort_order = 'id_asc'
  config.filters = false

  index download_links: [:csv] do
    column :name
    column :deleted_at
    actions defaults: false do |role|
      if role.deleted_at?
        item I18n.t('active_admin.restore', default: 'Restore'), restore_admin_role_path(role),
             method: :put
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end

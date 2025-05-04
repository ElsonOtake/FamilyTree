ActiveAdmin.register User do
  menu priority: 1
  permit_params :name, :email, :phone, :password, :password_confirmation

  config.sort_order = 'id_asc'

  filter :name
  filter :email
  filter :locale
  filter :provider
  filter :phone
  filter :created_at

  index pagination_total: false, download_links: [:csv] do
    id_column
    column :name
    column :email
    column :locale
    column :provider
    column :phone
    column :created_at
    column :roles do |user|
      user.roles.map(&:name).join(", ")
    end
    actions do |user|
      item I18n.t("active_admin.events"), admin_events_path(q: { user_id_eq: user.id }), class: "preview-link"
    end
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :email
      row :locale
      row :provider
      row :phone
      row :created_at
      row :events do |user|
        link_to "Events", admin_events_path(q: { user_id_eq: user.id }), class: "preview-link"
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :phone
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end

ActiveAdmin.register Person do
  menu priority: 3

  actions :index, :show
  restorable!

  config.sort_order = 'id_asc'

  filter :name
  filter :kanji
  filter :gender_eq, as: :select, collection: Person.genders
  filter :alive
  filter :birth
  filter :death
  filter :description
  filter :created_at
  filter :updated_at

  index pagination_total: false, download_links: [:csv] do
    id_column
    column :name
    column :kanji
    column :gender
    column :alive
    column :birth
    column :death
    column :description
    column :created_at
    column :updated_at
    column :deleted_at
    actions do |person|
      item I18n.t("active_admin.events"), admin_events_path(q: { resource_type_eq: person.class, resource_id_eq: person.id }), class: "preview-link"
      item I18n.t("active_admin.restore", default: "Restore"), restore_admin_person_path(person), method: :put if person.deleted_at?
    end
  end

  action_item :restore, only: :show, if: -> { resource.deleted_at? } do
    link_to I18n.t("active_admin.restore", default: "Restore"), restore_admin_person_path(resource), method: :put
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :kanji
      row :gender
      row :alive
      row :birth
      row :death
      row :description
      row :created_at
      row :updated_at
      row :deleted_at
      row :events do
        link_to "Events", admin_events_path(q: { resource_type_eq: resource.class, resource_id_eq: resource.id }), class: "preview-link"
      end
    end
  end
end

ActiveAdmin.register Couple do
  menu priority: 4

  includes :person1, :person2

  actions :index, :show

  filter :person1_name_or_person2_name_cont, as: :string, label: 'Person Name'
  filter :marriage
  filter :separation
  filter :local
  filter :created_at
  filter :updated_at

  index pagination_total: false, download_links: [:csv] do
    id_column
    column 'Person 1', :person1_id, sortable: false do |couple|
      Person.find(couple.person1_id).name
    end
    column 'Person 2', :person2_id, sortable: false do |couple|
      Person.find(couple.person2_id).name
    end
    column :marriage
    column :separation
    column :local
    column :created_at
    column :updated_at
    actions do |couple|
      item I18n.t("active_admin.events"), admin_events_path(q: { resource_type_eq: couple.class, resource_id_eq: couple.id }), class: "preview-link"
    end
  end

  show do
    attributes_table_for(resource) do
      row :id
      row 'Person 1', :person1_id do |couple|
        link_to Person.find(couple.person1_id).name, admin_person_path(couple.person1_id)
      end
      row 'Person 2', :person2_id do |couple|
        link_to Person.find(couple.person2_id).name, admin_person_path(couple.person2_id)
      end
      row :marriage
      row :separation
      row :local
      row :created_at
      row :updated_at
      row :events do
        link_to "Events", admin_events_path(q: { resource_type_eq: resource.class, resource_id_eq: resource.id }), class: "preview-link"
      end
    end
  end
end

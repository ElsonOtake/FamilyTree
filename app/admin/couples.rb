ActiveAdmin.register Couple do
  menu priority: 4

  actions :index
  restorable!

  filter :person1_name_or_person2_name_cont, as: :string, label: 'Person Name'
  filter :marriage
  filter :separation
  filter :local
  filter :created_at
  filter :updated_at
  filter :deleted_at

  index pagination_total: false, download_links: [:csv] do
    id_column
    column 'Person 1', :person1_id, sortable: false do |couple|
      Person.with_deleted.find_by(id: couple.person1_id)&.name
    end
    column 'Person 2', :person2_id, sortable: false do |couple|
      Person.with_deleted.find_by(id: couple.person2_id)&.name
    end
    column :marriage
    column :separation
    column :local
    column :created_at
    column :updated_at
    column :deleted_at
    actions defaults: false do |couple|
      item I18n.t('active_admin.restore', default: 'Restore'), restore_admin_couple_path(couple), method: :put if couple.deleted_at?
    end
  end
end

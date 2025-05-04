ActiveAdmin.register Person do
  menu priority: 3

  actions :index

  config.sort_order = 'id_asc'

  filter :name
  filter :kanji
  filter :gender_eq, as: :select, collection: Person.genders
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
    # actions do |user|
    #   item I18n.t("active_admin.events"), admin_events_path(q: { user_id_eq: user.id }), class: "preview-link"
    # end
  end
end

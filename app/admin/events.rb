ActiveAdmin.register Event do
  menu priority: 2

  actions :index

  index download_links: [:csv]

  # includes :author, :categories

  # belongs_to :project

  # belongs_to :project, optional: true

  # config.default_per_page = 30

  # config.per_page = 10

  # config.per_page = [10, 50, 100]

  # index download_links: proc{ current_user.can_view_download_links? }

  # sidebar "Project Details", only: [:show, :edit] do
  #   ul do
  #     li link_to "Tickets",    admin_project_tickets_path(resource)
  #     li link_to "Milestones", admin_project_milestones_path(resource)
  #   end
  # end

  # index pagination_total: false do
  #   # ...
  # end
end

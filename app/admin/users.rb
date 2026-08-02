ActiveAdmin.register User do
  menu priority: 1

  # Admins only manage a user's role and access here. Users change their own
  # name / email / phone / password via "Editar Perfil"; account creation happens
  # through registration, so the admin new/create form is disabled.
  permit_params :role
  actions :all, except: %i[new create]

  config.sort_order = 'id_asc'

  filter :id
  filter :name
  filter :email
  filter :locale
  filter :provider
  filter :phone
  filter :created_at
  filter :confirmed_at
  filter :approved

  index pagination_total: false, download_links: [:csv] do
    id_column
    column :name
    column :email
    column :locale
    column :provider
    column :phone
    column :created_at
    column :confirmation_status do |user|
      status_tag(user.confirmed? ? 'Confirmed' : 'Unconfirmed', class: user.confirmed? ? 'ok' : 'error')
    end
    column :approval_status do |user|
      status_tag(user.approved? ? 'Approved' : 'Pending', class: user.approved? ? 'ok' : 'warning')
    end
    column :roles do |user|
      user.roles.map(&:name).join(', ')
    end
    actions do |user|
      item I18n.t('active_admin.events'), admin_events_path(q: { user_id_eq: user.id }), class: 'preview-link'
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
      row :confirmation_status do |user|
        user.confirmed? ? "Confirmed at #{user.confirmed_at.strftime('%B %d, %Y at %I:%M %p')}" : 'Not confirmed'
      end
      row :approval_status do |user|
        status_tag(user.approved? ? 'Approved' : 'Pending', class: user.approved? ? 'ok' : 'warning')
      end
      row :roles do |user|
        user.roles.map(&:name).join(', ')
      end
      row :events do |user|
        link_to 'Events', admin_events_path(q: { user_id_eq: user.id }), class: 'preview-link'
      end
    end
  end

  # The edit page manages the role (form) and access/approval (sidebar).
  form do |f|
    f.inputs 'Role' do
      f.input :role, as: :select, collection: %w[bronze silver gold admin], include_blank: false
    end
    f.actions
  end

  sidebar 'Access', only: :edit do
    div class: 'admin-user-access' do
      unless resource.confirmed?
        span(link_to('Confirm e-mail', confirm_admin_user_path(resource), method: :patch,
                                                                          data: { confirm: "Confirm this user's e-mail?" }, class: 'button'))
      end
      if resource.approved?
        span(link_to('Revoke Approval', unapprove_admin_user_path(resource), method: :patch,
                                                                             data: { confirm: "Revoke this user's access?" }, class: 'button'))
      else
        span(link_to('Approve User', approve_admin_user_path(resource), method: :patch,
                                                                        data: { confirm: 'Approve this user\'s access? They will be notified by e-mail.' }, class: 'button'))
      end
    end
  end

  member_action :confirm, method: :patch do
    resource.confirm
    redirect_to edit_admin_user_path(resource), notice: 'User has been confirmed successfully.'
  end

  member_action :approve, method: :patch do
    resource.approve!
    redirect_to edit_admin_user_path(resource), notice: 'User approved. A confirmation e-mail has been sent.'
  end

  member_action :unapprove, method: :patch do
    resource.unapprove!
    redirect_to edit_admin_user_path(resource), notice: 'User approval revoked.'
  end

  # Audit role changes to match the app's own roles page (Current.user isn't set
  # for ActiveAdmin, so read the actor from current_user here).
  controller do
    def update
      old_roles = resource.roles.pluck(:name)
      super
      new_roles = resource.reload.roles.pluck(:name)
      return if old_roles.sort == new_roles.sort

      current_user.events.create(name: 'role.update',
                                 data: { user_id: resource.id, old_roles: old_roles, new_roles: new_roles })
    end
  end
end

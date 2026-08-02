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
      f.input :role, as: :select, collection: User::ROLES, include_blank: false
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
      span(link_to('Send Password Reset', send_reset_password_admin_user_path(resource), method: :patch,
                                                                                         data: { confirm: 'E-mail this user a password reset link?' }, class: 'button'))
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

  # A locked-out user can't self-serve via "Editar Perfil", so let an admin send
  # the Devise reset-password e-mail (we never set passwords from the admin).
  member_action :send_reset_password, method: :patch do
    resource.send_reset_password_instructions
    redirect_to edit_admin_user_path(resource), notice: 'Password reset e-mail sent.'
  end

  controller do
    # Avoid an N+1 on the index's roles column.
    def scoped_collection
      super.includes(:roles)
    end

    # Role is the only editable field; route it through User#update_role!, which
    # validates the name, swaps roles in one transaction, and audits the change
    # against the acting admin (matching UsersController#role_update).
    def update
      if resource.update_role!(params.dig(:user, :role), actor: current_user)
        redirect_to edit_admin_user_path(resource), notice: 'Role updated.'
      else
        redirect_to edit_admin_user_path(resource), alert: 'Please choose a valid role.'
      end
    end
  end
end

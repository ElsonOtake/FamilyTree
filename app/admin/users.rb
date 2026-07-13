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
      if user.confirmed?
        status_tag "Confirmed", class: 'ok'
      else
        status_tag "Unconfirmed", class: 'error'
      end
    end
    column :approval_status do |user|
      if user.approved?
        status_tag "Approved", class: 'ok'
      else
        status_tag "Pending", class: 'warning'
      end
    end
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
      row :confirmation_status do |user|
        if user.confirmed?
          "Confirmed at #{user.confirmed_at.strftime('%B %d, %Y at %I:%M %p')}"
        else
          "Not confirmed"
        end
      end
      row :approval_status do |user|
        status_tag(user.approved? ? 'Approved' : 'Pending', class: user.approved? ? 'ok' : 'warning')
      end
      row :events do |user|
        link_to "Events", admin_events_path(q: { user_id_eq: user.id }), class: "preview-link"
      end
    end
    
    panel "Admin Actions" do
      div do
        unless resource.confirmed?
          span(link_to("Confirm User", confirm_admin_user_path(resource), method: :patch,
                                                                          data: { confirm: "Confirm this user's e-mail?" }, class: "button"))
        end
        if resource.approved?
          span(link_to("Revoke Approval", unapprove_admin_user_path(resource), method: :patch,
                                                                               data: { confirm: "Revoke this user's access?" }, class: "button"))
        else
          span(link_to("Approve User", approve_admin_user_path(resource), method: :patch,
                                                                          data: { confirm: "Approve this user's access to the data? They will be notified by e-mail." }, class: "button"))
        end
      end
    end
  end

  member_action :confirm, method: :patch do
    resource.confirm
    redirect_to admin_user_path(resource), notice: 'User has been confirmed successfully.'
  end

  member_action :approve, method: :patch do
    resource.approve!
    redirect_to admin_user_path(resource), notice: 'User approved. A confirmation e-mail has been sent.'
  end

  member_action :unapprove, method: :patch do
    resource.unapprove!
    redirect_to admin_user_path(resource), notice: 'User approval revoked.'
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

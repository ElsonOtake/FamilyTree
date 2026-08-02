# frozen_string_literal: true

require 'test_helper'

# The ActiveAdmin user page manages only the role (users self-edit their own
# name/email/phone/password) and the approval/confirmation access actions.
class AdminUsersTest < ActionDispatch::IntegrationTest
  setup do
    %w[admin bronze gold].each { |r| Role.find_or_create_by(name: r) }
    @admin = users(:one)
    @admin.add_role(:admin)
    post user_session_path, params: { user: { email: @admin.email, password: 'password' } }

    @target = User.create!(name: 'Target', email: "t-#{SecureRandom.hex(4)}@example.com",
                           password: 'password123', confirmed_at: Time.current, approved: false)
    @target.add_role(:bronze)
  end

  test 'the edit page renders a role-only form (no email/password fields)' do
    get edit_admin_user_path(@target)

    assert_response :success
    assert_select 'select[name=?]', 'user[role]'
    assert_select 'input[name=?]', 'user[email]', count: 0
    assert_select 'input[name=?]', 'user[password]', count: 0
  end

  test 'updating changes only the role and records a role.update event' do
    assert_difference -> { Event.where(name: 'role.update').count }, 1 do
      patch admin_user_path(@target), params: { user: { role: 'gold' } }
    end

    assert_equal ['gold'], @target.reload.roles.pluck(:name)
    event = Event.where(name: 'role.update').last
    assert_equal @admin, event.user
    assert_equal ['bronze'], event.data['old_roles']
    assert_equal ['gold'], event.data['new_roles']
  end

  test 'rejects a crafted invalid role name without minting a Role or auditing' do
    assert_no_difference 'Role.count' do
      assert_no_difference -> { Event.where(name: 'role.update').count } do
        patch admin_user_path(@target), params: { user: { role: 'superadmin' } }
      end
    end

    assert_redirected_to edit_admin_user_path(@target)
    assert_equal ['bronze'], @target.reload.roles.pluck(:name)
  end

  test 'send password reset e-mails the user (for locked-out accounts)' do
    patch send_reset_password_admin_user_path(@target)

    assert_redirected_to edit_admin_user_path(@target)
    assert @target.reload.reset_password_token.present?, 'a reset token should be set'
  end

  test 'approve then revoke access via the member actions' do
    patch approve_admin_user_path(@target)
    assert @target.reload.approved?, 'user should be approved'

    patch unapprove_admin_user_path(@target)
    assert_not @target.reload.approved?, 'user approval should be revoked'
  end
end

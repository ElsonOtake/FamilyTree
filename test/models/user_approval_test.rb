# frozen_string_literal: true

require 'test_helper'

class UserApprovalTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  def build_user(**attrs)
    User.new({ name: 'Pending', email: 'pending@example.com', password: 'password123',
               confirmed_at: Time.current }.merge(attrs))
  end

  test 'new users default to unapproved and cannot authenticate' do
    user = build_user
    user.save!

    assert_not user.approved?
    assert_not user.active_for_authentication?
    assert_equal :not_approved, user.inactive_message
  end

  test 'an approved, confirmed user can authenticate' do
    user = build_user(approved: true)
    user.save!

    assert user.active_for_authentication?
  end

  test 'approve! grants access and emails the user' do
    user = build_user
    user.save!

    assert_enqueued_email_with(UserMailer, :approved, params: { user: user }) do
      assert user.approve!
    end
    assert user.reload.approved?
  end

  test 'approve! is a no-op for an already approved user' do
    user = build_user(approved: true)
    user.save!

    assert_no_enqueued_emails do
      assert_not user.approve!
    end
  end

  test 'unapprove! revokes access' do
    user = build_user(approved: true)
    user.save!

    user.unapprove!
    assert_not user.reload.approved?
    assert_not user.active_for_authentication?
  end

  test 'existing fixture users are approved' do
    assert users(:one).approved?
  end
end

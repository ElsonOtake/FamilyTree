# frozen_string_literal: true

require 'test_helper'

class UserTrackingIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    # Create roles if they don't exist
    Role.find_or_create_by(name: 'admin')
    Role.find_or_create_by(name: 'editor')
    Role.find_or_create_by(name: 'bronze')

    @admin = users(:admin)
    @admin.add_role(:admin) # Add admin role
    @user = users(:one)
    @user.add_role(:bronze) # Add default role
    @user.update!(
      current_sign_in_at: Time.zone.parse('2025-09-20 20:30:00 UTC'),
      sign_in_count: 5
    )
    sign_in_as(@admin)
  end

  test 'timezone conversion works correctly for São Paulo timezone' do
    # Test timezone calculation directly
    utc_time = Time.zone.parse('2025-09-20 20:30:00 UTC')
    sao_paulo_time = utc_time.in_time_zone('America/Sao_Paulo')

    assert_equal '17:30', sao_paulo_time.strftime('%H:%M')
  end

  test 'user model stores sign-in data correctly' do
    @user.update!(
      current_sign_in_at: Time.zone.parse('2025-09-20 15:45:00 UTC'),
      sign_in_count: 3
    )

    @user.reload
    assert_not_nil @user.current_sign_in_at
    assert_equal 3, @user.sign_in_count
  end

  test 'handles user with no sign-in data gracefully' do
    @user.update!(current_sign_in_at: nil, sign_in_count: 0)
    @user.reload

    assert_nil @user.current_sign_in_at
    assert_equal 0, @user.sign_in_count
  end

  test 'user tracking data updates on sign-in' do
    # Sign in as the tracked user
    delete destroy_user_session_path

    # Record the time before sign-in
    before_sign_in = Time.current

    # Sign in
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: 'password'
      }
    }

    # Check that trackable fields were updated
    @user.reload
    assert_not_nil @user.current_sign_in_at
    assert @user.current_sign_in_at >= before_sign_in
    assert_equal 6, @user.sign_in_count # Should increment from 5 to 6
  end

  private

  def sign_in_as(user)
    post user_session_path, params: {
      user: {
        email: user.email,
        password: 'password'
      }
    }
  end
end

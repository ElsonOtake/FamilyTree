# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def sign_in(user)
    visit new_user_session_url

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'

    within('#new_user') do
      find('input[type="submit"]').click
    end

    assert_no_current_path new_user_session_path
  end
end

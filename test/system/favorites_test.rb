# frozen_string_literal: true

require 'application_system_test_case'

class FavoritesTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @user.add_role(:admin)
    @person = people(:one)

    sign_in @user
  end

  test 'should toggle the favorite status' do
    visit person_url(@person)

    assert_selector 'h1', text: @person.name

    assert_button I18n.t('favorites.add')

    click_on I18n.t('favorites.add')

    assert_text I18n.t('favorites.added')

    assert_button I18n.t('favorites.remove')

    click_on I18n.t('favorites.remove')

    assert_text I18n.t('favorites.removed')

    click_on I18n.t('back')
  end
end

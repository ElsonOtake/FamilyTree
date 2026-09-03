# frozen_string_literal: true

require 'application_system_test_case'

class ChildrenTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @user.add_role(:admin)
    @person = people(:one)
    @couple = couples(:one)

    sign_in @user
  end

  test 'should create and unlink Child' do
    @child_name = 'Luna'

    visit person_url(@person)

    assert_selector 'span', text: I18n.t('people.show.mate')

    click_on I18n.t('helpers.submit.create', model: I18n.t('children.form.child')), match: :first

    assert_selector 'h1', text: "#{I18n.t('helpers.submit.create', model: I18n.t('children.form.child'))} — #{@person.name}"

    fill_in 'person_name', with: @child_name
    fill_in 'person_description', with: 'Mixed breed dog'

    fill_in 'person_birth_year',  with: 2012
    fill_in 'person_birth_month', with: 10
    fill_in 'person_birth_day',   with: 21

    find('input[name="person[gender]"][value="P"]').choose

    find("input[name='person[alive]'][value='true']").choose

    sleep 2

    assert_button I18n.t('people.form.create_person')

    click_on I18n.t('people.form.create_person')

    assert_text I18n.t('activerecord.success.messages.created', model: I18n.t('children.form.child'))

    # The unlink icon link's accessible name comes from its title attribute
    accept_confirm(I18n.t('confirm.messages.unlink_child', name: @child_name)) do
      click_on I18n.t(
        'helpers.submit.unlink',
        model: I18n.t('children.form.child')
      ), match: :first
      sleep 2
    end

    assert_text I18n.t('activerecord.success.messages.unlinked', model: I18n.t('children.form.child'))
    click_on I18n.t('back')
  end
end

# frozen_string_literal: true

require 'application_system_test_case'

class PeopleTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @user.add_role(:admin)
    @person = people(:one)

    sign_in @user
  end

  test 'visiting the index' do
    visit people_url
    assert_selector 'h1', text: I18n.t('people.index.family_tree')
    assert_selector 'p', text: I18n.t('people.index.search_by_name')
  end

  test 'should create person' do
    visit people_url
    click_on I18n.t('helpers.submit.create', model: I18n.t('people.form.person'))

    fill_in 'person_name', with: @person.name
    fill_in 'person_description', with: @person.description

    fill_in 'person_birth_year',  with: @person.birth&.year
    fill_in 'person_birth_month', with: @person.birth&.month
    fill_in 'person_birth_day',   with: @person.birth&.day

    fill_in 'person_death_year',  with: @person.death&.year
    fill_in 'person_death_month', with: @person.death&.month
    fill_in 'person_death_day',   with: @person.death&.day

    find('input[name="person[gender]"][value="M"]').choose if @person.gender == 'M'
    find('input[name="person[gender]"][value="F"]').choose if @person.gender == 'F'
    find('input[name="person[gender]"][value="P"]').choose if @person.gender == 'P'
    find('input[name="person[gender]"][value="X"]').choose if @person.gender == 'X'

    find("input[name='person[alive]'][value='true']").choose if @person.alive
    find("input[name='person[alive]'][value='false']").choose unless @person.alive

    sleep 5

    click_on I18n.t('people.form.create_person')

    assert_text I18n.t('activerecord.success.messages.created', model: I18n.t('people.form.person'))
    click_on I18n.t('back')
  end

  test 'should update Person' do
    visit person_url(@person)

    assert_selector 'h1', text: @person.name

    click_on I18n.t('helpers.submit.edit', model: I18n.t('people.form.person')), match: :first

    fill_in 'person_name', with: "#{@person.name} updated"
    fill_in 'person_description', with: "#{@person.description} updated"

    sleep 5

    click_on I18n.t('people.form.update_person')

    assert_text I18n.t('activerecord.success.messages.updated', model: I18n.t('people.form.person'))
    click_on I18n.t('back')
  end

  test 'should destroy Person' do
    visit person_url(@person)
    accept_confirm(I18n.t('people.show.delete_confirmation', name: @person.name)) do
      click_on I18n.t(
        'helpers.submit.delete',
        model: I18n.t('people.form.person')
      ), match: :first
    end

    assert_text I18n.t(
      'activerecord.success.messages.deleted',
      model: I18n.t('people.form.person')
    )
  end
end

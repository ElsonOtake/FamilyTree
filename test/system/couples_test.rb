# frozen_string_literal: true

require 'application_system_test_case'

class CouplesTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @user.add_role(:admin)
    @person = people(:one)
    @other_person = people(:two)
    @couple = couples(:one)

    sign_in @user
  end

  test 'should create couple' do
    visit person_url(@person)

    assert_selector 'span', text: I18n.t('people.show.mate')

    click_on I18n.t('people.show.add')

    assert_selector 'h1', text: "#{I18n.t('helpers.submit.create', model: I18n.t('people.show.mate'))} — #{@person.name}"
    assert_selector 'h3', text: I18n.t('people.form.relationship_info')

    fill_in 'person_name', with: @other_person.name
    fill_in 'person_description', with: @other_person.description

    fill_in 'person_birth_year',  with: @other_person.birth&.year
    fill_in 'person_birth_month', with: @other_person.birth&.month
    fill_in 'person_birth_day',   with: @other_person.birth&.day

    fill_in 'person_death_year',  with: @other_person.death&.year
    fill_in 'person_death_month', with: @other_person.death&.month
    fill_in 'person_death_day',   with: @other_person.death&.day

    find('input[name="person[gender]"][value="M"]').choose if @other_person.gender == 'M'
    find('input[name="person[gender]"][value="F"]').choose if @other_person.gender == 'F'
    find('input[name="person[gender]"][value="P"]').choose if @other_person.gender == 'P'
    find('input[name="person[gender]"][value="X"]').choose if @other_person.gender == 'X'

    find("input[name='person[alive]'][value='true']").choose if @other_person.alive
    find("input[name='person[alive]'][value='false']").choose unless @other_person.alive

    fill_in 'person_marriage', with: Date.today
    fill_in 'person_local', with: 'Athens'

    sleep 2

    click_on I18n.t('people.form.create_person')

    assert_text I18n.t('activerecord.success.messages.created', model: I18n.t('couples.form.couple'))
    click_on I18n.t('back')
  end

  test 'should update Couple' do
    visit person_url(@person)

    sleep 2

    # The pencil icon link's accessible name comes from its title attribute
    click_on I18n.t('helpers.submit.edit', model: I18n.t('people.show.mate')), match: :first

    sleep 2

    fill_in 'couple_marriage', with: Date.new(2020, 6, 15)
    fill_in 'couple_separation', with: Date.new(2022, 1, 1)
    fill_in 'couple_local', with: 'Updated Location'

    click_on I18n.t('couples.form.update_couple')

    assert_text I18n.t('activerecord.success.messages.updated', model: I18n.t('couples.form.couple'))
    click_on I18n.t('back')
  end

  test 'should destroy Couple' do
    visit person_url(@person)

    # The unlink icon link's accessible name comes from its title attribute
    accept_confirm(I18n.t('confirm.messages.unlink_mate', person_name: @person.name, mate_name: @other_person.name)) do
      click_on I18n.t(
        'helpers.submit.unlink',
        model: I18n.t('people.show.mate')
      ), match: :first
      sleep 2
    end

    assert_text I18n.t('activerecord.success.messages.unlinked', model: I18n.t('couples.form.couple'))
    click_on I18n.t('back')
  end
end

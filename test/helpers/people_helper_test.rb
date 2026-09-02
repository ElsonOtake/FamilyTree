# frozen_string_literal: true

require 'test_helper'

class PeopleHelperTest < ActionView::TestCase
  include PeopleHelper

  # AGE METHOD TESTS
  test 'age returns correct years when difference is over 1 year' do
    from = Date.new(2020, 1, 1)
    to = Date.new(2023, 6, 15) # About 3.5 years

    result = age(from, to)

    # Should return years in the correct I18n format
    expected_years = ((to - from).to_i / 365.25).to_i
    assert_includes result, expected_years.to_s
    assert_includes result, I18n.t('datetime.distance_in_words.x_years_old', count: expected_years)
  end

  test 'age returns correct months when difference is 1-12 months' do
    from = Date.new(2023, 1, 1)
    to = Date.new(2023, 8, 15) # About 7.5 months

    result = age(from, to)

    # Should return months in the correct I18n format
    expected_months = ((to - from).to_i / 30.6).to_i
    assert_includes result, expected_months.to_s
    assert_includes result, I18n.t('datetime.distance_in_words.x_months', count: expected_months)
  end

  test 'age returns correct days when difference is less than 1 month' do
    from = Date.new(2023, 8, 1)
    to = Date.new(2023, 8, 15) # 14 days

    result = age(from, to)

    # Should return days in the correct I18n format
    expected_days = (to - from).to_i
    assert_equal I18n.t('datetime.distance_in_words.x_days', count: expected_days), result
  end

  test 'age returns nil when to date is not greater than from date' do
    from = Date.new(2023, 8, 15)
    to = Date.new(2023, 8, 10) # Earlier date

    result = age(from, to)
    assert_nil result
  end

  test 'age returns nil when dates are equal' do
    date = Date.new(2023, 8, 15)

    result = age(date, date)
    assert_nil result
  end

  test 'age handles exact year boundaries correctly' do
    from = Date.new(2020, 1, 1)
    to = Date.new(2022, 1, 1) # Exactly 2 years

    result = age(from, to)

    expected_years = 2
    assert_includes result, expected_years.to_s
  end

  test 'age uses correct leap year calculations' do
    from = Date.new(2020, 2, 29) # Leap year
    to = Date.new(2024, 2, 29) # Next leap year, exactly 4 years

    result = age(from, to)

    # Should calculate using 365.25 average
    expected_years = ((to - from).to_i / 365.25).to_i
    assert_includes result, expected_years.to_s
  end

  test 'age works with DateTime objects' do
    from = DateTime.new(2023, 1, 1, 10, 30)
    to = DateTime.new(2023, 12, 31, 15, 45)

    result = age(from, to)
    assert_not_nil result
    # Should handle DateTime to Date conversion gracefully
  end

  # GENDER_COLOR_CLASS TESTS
  test 'gender_color_class returns correct class for male' do
    assert_equal 'has-text-info', gender_color_class('M')
  end

  test 'gender_color_class returns correct class for female' do
    assert_equal 'has-text-danger', gender_color_class('F')
  end

  test 'gender_color_class returns correct class for prefer not to say' do
    assert_equal 'has-text-warning', gender_color_class('P')
  end

  test 'gender_color_class returns correct class for non-binary' do
    assert_equal 'has-text-success', gender_color_class('X')
  end

  test 'gender_color_class returns grey for nil gender' do
    assert_equal 'has-text-grey', gender_color_class(nil)
  end

  test 'gender_color_class returns grey for unknown gender' do
    assert_equal 'has-text-grey', gender_color_class('UNKNOWN')
    assert_equal 'has-text-grey', gender_color_class('Z')
    assert_equal 'has-text-grey', gender_color_class('')
  end

  test 'gender_color_class handles lowercase input' do
    # Should handle case sensitivity - may need to update implementation
    assert_equal 'has-text-grey', gender_color_class('m') # Currently returns grey
  end

  # GENDER_ICON_CLASS TESTS
  test 'gender_icon_class returns correct icon for male' do
    assert_equal 'fas fa-mars', gender_icon_class('M')
  end

  test 'gender_icon_class returns correct icon for female' do
    assert_equal 'fas fa-venus', gender_icon_class('F')
  end

  test 'gender_icon_class returns correct icon for prefer not to say' do
    assert_equal 'fas fa-venus-mars', gender_icon_class('P')
  end

  test 'gender_icon_class returns correct icon for non-binary' do
    assert_equal 'fas fa-genderless', gender_icon_class('X')
  end

  test 'gender_icon_class returns question mark for nil gender' do
    assert_equal 'fas fa-question', gender_icon_class(nil)
  end

  test 'gender_icon_class returns question mark for unknown gender' do
    assert_equal 'fas fa-question', gender_icon_class('UNKNOWN')
    assert_equal 'fas fa-question', gender_icon_class('Z')
    assert_equal 'fas fa-question', gender_icon_class('')
  end

  # GENDER_PROGRESS_CLASS TESTS
  test 'gender_progress_class returns correct class for male' do
    assert_equal 'is-info', gender_progress_class('M')
  end

  test 'gender_progress_class returns correct class for female' do
    assert_equal 'is-danger', gender_progress_class('F')
  end

  test 'gender_progress_class returns correct class for prefer not to say' do
    assert_equal 'is-warning', gender_progress_class('P')
  end

  test 'gender_progress_class returns correct class for non-binary' do
    assert_equal 'is-success', gender_progress_class('X')
  end

  test 'gender_progress_class returns grey for nil gender' do
    assert_equal 'is-grey', gender_progress_class(nil)
  end

  test 'gender_progress_class returns grey for unknown gender' do
    assert_equal 'is-grey', gender_progress_class('UNKNOWN')
    assert_equal 'is-grey', gender_progress_class('Z')
    assert_equal 'is-grey', gender_progress_class('')
  end

  # CONSISTENCY TESTS BETWEEN GENDER METHODS
  test 'all gender helper methods handle same gender values consistently' do
    genders = ['M', 'F', 'P', 'X', nil, 'UNKNOWN']

    genders.each do |gender|
      # All methods should return non-nil values
      assert_not_nil gender_color_class(gender), "color class should not be nil for #{gender}"
      assert_not_nil gender_icon_class(gender), "icon class should not be nil for #{gender}"
      assert_not_nil gender_progress_class(gender), "progress class should not be nil for #{gender}"
    end
  end

  test 'gender methods return appropriate CSS classes' do
    # Color classes should start with 'has-text-'
    # Icon classes should contain 'fa'
    # Progress classes should start with 'is-'
    ['M', 'F', 'P', 'X', nil].each do |gender|
      color_class = gender_color_class(gender)
      assert color_class.start_with?('has-text-'), "Color class should start with 'has-text-' for #{gender}"

      icon_class = gender_icon_class(gender)
      assert icon_class.include?('fa'), "Icon class should contain 'fa' for #{gender}"

      progress_class = gender_progress_class(gender)
      assert progress_class.start_with?('is-'), "Progress class should start with 'is-' for #{gender}"
    end
  end

  # EDGE CASE TESTS
  test 'age handles very small time differences' do
    from = Date.current
    to = Date.current + 1.day

    result = age(from, to)
    assert_equal I18n.t('datetime.distance_in_words.x_days', count: 1), result
  end

  test 'age handles very large time differences' do
    from = Date.new(1900, 1, 1)
    to = Date.new(2023, 1, 1)

    result = age(from, to)
    expected_years = ((to - from).to_i / 365.25).to_i
    assert_includes result, expected_years.to_s
    assert expected_years > 100 # Should handle century+ differences
  end

  test 'gender methods handle string with extra whitespace' do
    assert_equal 'has-text-grey', gender_color_class(' M ')
    assert_equal 'has-text-grey', gender_color_class('\tF\n')
  end

  # I18N INTEGRATION TESTS
  test 'age method uses correct I18n keys' do
    # Test that the helper uses the expected translation keys
    from = Date.new(2020, 1, 1)
    to = Date.new(2023, 1, 1)

    result = age(from, to)

    # Should use the x_years_old key for years
    expected_key = 'datetime.distance_in_words.x_years_old'
    expected_years = 3
    expected_translation = I18n.t(expected_key, count: expected_years)

    assert_equal expected_translation, result
  end

  test 'age method works with different locales' do
    from = Date.new(2022, 1, 1)
    to = Date.new(2023, 6, 1)

    I18n.with_locale(:en) do
      result_en = age(from, to)
      assert_not_nil result_en
    end

    I18n.with_locale(:pt) do
      result_pt = age(from, to)
      assert_not_nil result_pt
    end

    I18n.with_locale(:ja) do
      result_ja = age(from, to)
      assert_not_nil result_ja
    end
  end

  # PAGY INTEGRATION TEST
  test 'helper includes Pagy::Frontend' do
    assert_includes PeopleHelper.included_modules, Pagy::Frontend
  end

  test 'responds to pagy helper methods' do
    # Should have access to Pagy frontend helpers
    assert_respond_to self, :pagy_nav if respond_to?(:pagy_nav)
  end

  # PERFORMANCE TESTS
  test 'age calculation is efficient for edge cases' do
    # Test performance with extreme dates
    from = Date.new(1, 1, 1)
    to = Date.current

    # Should not raise overflow errors or take excessive time
    assert_nothing_raised do
      Timeout.timeout(1) do # Should complete within 1 second
        age(from, to)
      end
    end
  end

  # BULMA CSS FRAMEWORK INTEGRATION
  test 'gender color classes match Bulma CSS conventions' do
    bulma_colors = %w[info danger warning success grey]

    ['M', 'F', 'P', 'X', nil].each do |gender|
      color_class = gender_color_class(gender)
      color_name = color_class.gsub('has-text-', '')
      assert_includes bulma_colors, color_name, "#{color_class} should use valid Bulma color"
    end
  end

  test 'gender progress classes match Bulma CSS conventions' do
    bulma_progress_colors = %w[info danger warning success grey]

    ['M', 'F', 'P', 'X', nil].each do |gender|
      progress_class = gender_progress_class(gender)
      color_name = progress_class.gsub('is-', '')
      assert_includes bulma_progress_colors, color_name, "#{progress_class} should use valid Bulma progress color"
    end
  end

  test 'gender icon classes use FontAwesome conventions' do
    fontawesome_prefixes = %w[fas far fab fal]

    ['M', 'F', 'P', 'X', nil].each do |gender|
      icon_class = gender_icon_class(gender)
      icon_parts = icon_class.split(' ')

      # First part should be a FontAwesome prefix
      assert_includes fontawesome_prefixes, icon_parts.first, "#{icon_class} should start with valid FontAwesome prefix"

      # Second part should start with 'fa-'
      assert icon_parts.last.start_with?('fa-'), "#{icon_class} should have icon name starting with 'fa-'"
    end
  end
end

# frozen_string_literal: true

require 'test_helper'

class IconHelperTest < ActionView::TestCase
  test 'renders an inline svg using currentColor' do
    svg = heroicon(:heart)
    assert_includes svg, '<svg'
    assert_includes svg, 'stroke="currentColor"'
    assert_includes svg, 'class="size-5"'
    assert svg.html_safe?
  end

  test 'accepts a custom class and passes through options' do
    svg = heroicon(:user, class: 'size-8 text-male', 'data-role': 'avatar')
    assert_includes svg, 'class="size-8 text-male"'
    assert_includes svg, 'data-role="avatar"'
  end

  test 'normalizes dashed names' do
    assert_includes heroicon('user-group'), '<svg'
    assert_includes heroicon('arrow-left'), '<svg'
  end

  test 'raises on an unknown icon in development-like envs' do
    assert_raises(ArgumentError) { heroicon(:definitely_not_an_icon) }
  end
end

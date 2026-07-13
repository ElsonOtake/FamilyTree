# frozen_string_literal: true

require 'test_helper'

module Pedigree
  class PortraitTest < ActiveSupport::TestCase
    test 'falls back to the silhouette when there is no avatar' do
      person = Person.new(name: 'No Avatar')

      assert_equal Portrait.silhouette, Portrait.data_for(person)
    end

    test 'silhouette returns non-empty PNG data' do
      data = Portrait.silhouette

      assert data.bytesize.positive?
      assert data.start_with?("\x89PNG".b)
    end

    test 'circular_avatar is nil for a person without an avatar' do
      assert_nil Portrait.circular_avatar(Person.new(name: 'None'))
    end
  end
end

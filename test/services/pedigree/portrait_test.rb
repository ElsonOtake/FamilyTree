# frozen_string_literal: true

require 'test_helper'

module Pedigree
  class PortraitTest < ActiveSupport::TestCase
    test 'falls back to the silhouette when there is no avatar' do
      person = Person.new(name: 'No Avatar', gender: 'M')

      assert_equal Portrait.silhouette('M'), Portrait.data_for(person)
    end

    test 'silhouette returns non-empty PNG data' do
      data = Portrait.silhouette

      assert data.bytesize.positive?
      assert data.start_with?("\x89PNG".b)
    end

    test 'oval_avatar is nil for a person without an avatar' do
      assert_nil Portrait.oval_avatar(Person.new(name: 'None'))
    end

    test 'picks a distinct silhouette per gender' do
      male = Portrait.silhouette('M')
      female = Portrait.silhouette('F')

      assert male.start_with?("\x89PNG".b)
      assert female.start_with?("\x89PNG".b)
      assert_not_equal male, female
    end

    test 'data_for uses the gendered silhouette' do
      assert_equal Portrait.silhouette('F'), Portrait.data_for(Person.new(name: 'She', gender: 'F'))
      assert_equal Portrait.silhouette('M'), Portrait.data_for(Person.new(name: 'He', gender: 'M'))
    end

    test 'other or missing genders use the neutral silhouette' do
      neutral = Portrait.silhouette

      assert_equal Portrait::DEFAULT_SILHOUETTE_PATH, Portrait.silhouette_path(nil)
      assert_equal Portrait::DEFAULT_SILHOUETTE_PATH, Portrait.silhouette_path('P')
      assert_equal Portrait::DEFAULT_SILHOUETTE_PATH, Portrait.silhouette_path('X')
      assert_equal neutral, Portrait.data_for(Person.new(name: 'Pet', gender: 'P'))
    end
  end
end

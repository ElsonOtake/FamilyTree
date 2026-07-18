# frozen_string_literal: true

require 'test_helper'

module Pedigree
  module Ancestors
    class PdfTest < ActiveSupport::TestCase
      setup do
        @user = User.create!(name: 'Recorder', email: 'rec@example.com',
                             password: 'password123', confirmed_at: Time.current)
        @focal = Person.create!(name: 'Focal', gender: 'X')
        father = Person.create!(name: 'Father', gender: 'M')
        mother = Person.create!(name: 'Mother', gender: 'F')
        parents = Couple.create!(person1: father, person2: mother)
        Child.create!(couple: parents, person: @focal, current_user: @user)
      end

      test 'renders a PDF for a person with ancestors' do
        data = Pdf.new(@focal).render

        assert data.start_with?('%PDF'), 'expected a PDF body'
        assert data.bytesize.positive?
      end

      test 'renders a PDF for a person with no recorded parents' do
        orphan = Person.create!(name: 'Orphan', gender: 'M')

        assert Pdf.new(orphan).render.start_with?('%PDF')
      end
    end
  end
end

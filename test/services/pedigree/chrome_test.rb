require 'test_helper'

module Pedigree
  class ChromeTest < ActiveSupport::TestCase
    # A minimal stand-in that mixes in Chrome so its private rendering helpers
    # can be exercised directly, without going through a full chart/layout/render.
    class DummyRenderer
      include Chrome

      public :measured_height, :register_fonts, :kanji_font_available?,
             :safe, :safe_utf8, :draw_name_line, :draw_kanji_line
    end

    setup do
      @renderer = DummyRenderer.new
      @pdf = Prawn::Document.new
    end

    # --- measured_height ---------------------------------------------------
    # Regression coverage for the NoMethodError: `pdf.font(name) { ... }`
    # returns the font object, not the block's value — measured_height must
    # capture the block's result itself rather than relying on font's return.

    test 'measured_height returns a numeric height, not a font object' do
      height = @renderer.measured_height(@pdf, 'Times-Bold', 'Short Name', 100, size: 7, cap: 20)

      assert_kind_of Numeric, height
      assert height.positive?
    end

    test 'measured_height does not raise for text that wraps to two lines' do
      long_name = 'Dom Pedro de Alcântara de Orleans e Bragança'
      assert_nothing_raised do
        @renderer.measured_height(@pdf, 'Times-Bold', long_name, 92, size: 7, cap: 20)
      end
    end

    test 'measured_height caps the result for text that would need more than the cap allows' do
      long_name = 'Dom Pedro de Alcântara de Orleans e Bragança'
      height = @renderer.measured_height(@pdf, 'Times-Bold', long_name, 40, size: 7, cap: 20)

      assert height <= 20
    end

    test 'measured_height grows for wrapped text, within the cap, vs a single short line' do
      short = @renderer.measured_height(@pdf, 'Times-Bold', 'A', 100, size: 7, cap: 20)
      wrapped = @renderer.measured_height(@pdf, 'Times-Bold', 'A Very Long Name That Wraps Lines', 40,
                                          size: 7, cap: 20)

      assert wrapped > short
    end

    # --- font availability / graceful degradation ---------------------------

    test 'kanji_font_available? is false before the font family is registered' do
      assert_not @renderer.kanji_font_available?(@pdf)
    end

    test 'kanji_font_available? is true once the font family is registered' do
      @pdf.font_families.update(Chrome::KANJI_FONT_NAME => { normal: Chrome::KANJI_FONT_REGULAR.to_s })

      assert @renderer.kanji_font_available?(@pdf)
    end

    test 'register_fonts does not raise when the font file is missing from disk' do
      # Simulates the state before the font asset is committed to the repo —
      # register_fonts should degrade silently rather than raising.
      assert_nothing_raised { @renderer.register_fonts(@pdf) }
    end

    # --- draw_kanji_line skip behavior --------------------------------------

    test 'draw_kanji_line leaves the cursor unchanged when the person has no kanji' do
      person = Person.new(name: 'No Kanji', gender: 'X', kanji: nil)
      top = 150

      result = @renderer.draw_kanji_line(@pdf, person, 0, 92, top)

      assert_equal top, result
    end

    test 'draw_kanji_line leaves the cursor unchanged when kanji is present but the font is unavailable' do
      person = Person.new(name: 'Has Kanji', gender: 'X', kanji: '稲富榮太郎')
      top = 150

      # No register_fonts call — the font family was never registered, so this
      # exercises the same fallback path as a not-yet-deployed font file.
      result = @renderer.draw_kanji_line(@pdf, person, 0, 92, top)

      assert_equal top, result
    end

    # --- draw_name_line advancement ------------------------------------------

    test 'draw_name_line advances the cursor by exactly the measured height, no extra gap' do
      layout = Struct.new(:generations).new(3)
      @renderer.instance_variable_set(:@layout, layout)

      person = Person.new(name: 'Plain Name', gender: 'X')
      top = 100
      width = 92

      expected_height = @renderer.measured_height(@pdf, 'Times-Bold', person.name, width,
                                                  size: 7, leading: 0.5, cap: 20)
      result = @renderer.draw_name_line(@pdf, person, 0, width, top)

      assert_equal top + expected_height, result
    end

    # --- safe_utf8 -----------------------------------------------------------

    test 'safe_utf8 passes kanji text through unchanged' do
      assert_equal '稲富榮太郎', @renderer.safe_utf8('稲富榮太郎')
    end

    test 'safe_utf8 returns an empty string for nil' do
      assert_equal '', @renderer.safe_utf8(nil)
    end
  end
end

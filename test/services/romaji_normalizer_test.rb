# frozen_string_literal: true

require 'test_helper'

# Verifies that spelling variants of the same romanized name canonicalize to
# the same string, which is what makes romanization-tolerant search work.
class RomajiNormalizerTest < ActiveSupport::TestCase
  def assert_same_normal(*variants)
    canonical = RomajiNormalizer.normalize(variants.first)
    variants.each do |v|
      assert_equal canonical, RomajiNormalizer.normalize(v),
                   "expected #{v.inspect} to normalize like #{variants.first.inspect}"
    end
  end

  test 'long-vowel spellings of Otake collapse together' do
    assert_same_normal('Otake', 'Ohtake', 'Ootake', 'Outake', 'Ōtake')
    assert_equal 'otake', RomajiNormalizer.normalize('Ohtake')
  end

  test 'Hepburn and Kunrei spellings of Michio collapse together' do
    assert_same_normal('Michio', 'Mitio')
    assert_equal 'mitio', RomajiNormalizer.normalize('Michio')
  end

  test 'other common Hepburn digraphs map to Kunrei' do
    assert_equal 'huzi', RomajiNormalizer.normalize('Fuji')
    assert_equal 'zyunko', RomajiNormalizer.normalize('Junko')
    assert_equal 'tetuya', RomajiNormalizer.normalize('Tetsuya')
    assert_equal 'syoitiro', RomajiNormalizer.normalize('Shouichirou')
  end

  test 'doubled consonants and n-before-labial collapse' do
    assert_same_normal('Hattori', 'Hatori')
    assert_same_normal('Namba', 'Nanba')
  end

  test 'accents and diacritics are stripped' do
    assert_equal 'marcio', RomajiNormalizer.normalize('Márcio')
    assert_same_normal('Márcio', 'Marcio')
    assert_same_normal('Antônio', 'Antonio')
    assert_same_normal('José', 'Jose')
  end

  test 'casing and surrounding whitespace are ignored' do
    assert_equal 'rafael yuki', RomajiNormalizer.normalize('  Rafael   YUKI ')
  end

  test 'nil and blank are handled' do
    assert_equal '', RomajiNormalizer.normalize(nil)
    assert_equal '', RomajiNormalizer.normalize('   ')
  end
end

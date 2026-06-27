# frozen_string_literal: true

# Canonicalizes romanized (rōmaji) names so spelling variants of the same
# Japanese name collapse to a single comparable form. The same transform is
# applied to stored names and to search queries, so it only has to be
# *consistent*, not linguistically perfect: as long as "Ohtake" and "Otake"
# (or "Michio" and "Mitio") map to the same string, a substring search matches.
#
# Roughly maps Hepburn and common long-vowel spellings onto Kunrei-shiki:
#   Ohtake / Ootake / Outake / Ōtake -> "otake"   (long vowels collapse)
#   Michio -> "mitio", Junko -> "zyunko"          (Hepburn digraphs -> Kunrei)
module RomajiNormalizer
  # Macron / circumflex long vowels -> plain vowel (paired by position).
  MACRONS = 'āīūēōâîûêô'
  PLAIN   = 'aiueoaiueo'

  # Ordered substitutions. Multi-character sequences come first so they win
  # over the shorter ones they contain (e.g. "shi" before any stray "sh").
  SUBSTITUTIONS = [
    # Long vowels -> single vowel
    %w[ou o], %w[oo o], %w[oh o], %w[uu u],
    # Hepburn consonant digraphs -> Kunrei-shiki
    %w[shi si], %w[sha sya], %w[shu syu], %w[sho syo],
    %w[chi ti], %w[cha tya], %w[chu tyu], %w[cho tyo],
    %w[tsu tu],
    %w[ji zi], %w[ja zya], %w[ju zyu], %w[jo zyo],
    %w[fu hu]
  ].freeze

  module_function

  def normalize(value)
    return '' if value.nil?

    s = value.to_s.downcase.tr(MACRONS, PLAIN)
    s = s.delete("'")                          # drop syllable-break apostrophes (shin'ichi)
    SUBSTITUTIONS.each { |from, to| s = s.gsub(from, to) }
    s = s.gsub(/m([bpm])/, 'n\1')              # Hepburn n -> m before b/p/m
    s = s.gsub(/([bcdfghjklmnpqrstvwxyz])\1/, '\1') # collapse doubled consonants (sokuon)
    s.squish                                   # collapse and trim whitespace
  end
end

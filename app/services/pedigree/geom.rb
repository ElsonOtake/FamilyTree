# frozen_string_literal: true

module Pedigree
  # Shared geometry (points) for the descendant chart, used by both the layout
  # (x positions) and the renderer (y positions and drawing).
  module Geom
    PORTRAIT_W  = 50   # oval portrait width
    PORTRAIT_H  = 64   # oval portrait height
    CELL_W      = 66   # horizontal cell per portrait
    SPOUSE_GAP  = 34   # gap between a person and their spouse portrait
    SIBLING_GAP = 40   # gap between sibling family units
    LABEL_H     = 68   # NAME_GAP(10) + name(≤20) + gap(3) + kanji(≤18) + gap(3) + years(12) + buffer
    NAME_GAP    = 10   # gap between a portrait and its name
    ROW_GAP     = 52   # vertical gap between generations
    MARGIN      = 52   # page margin (holds the decorative frame)
    TITLE_H     = 64   # title cartouche band at the top
    TITLE_GAP   = 40   # breathing room between the title and the first row
    FOOTER_H    = 46   # footer band (logo + credit) at the bottom
    LABEL_LINE_GAP = 3 # small breathing room between stacked label lines

    ROW_STEP = PORTRAIT_H + LABEL_H + ROW_GAP
  end
end

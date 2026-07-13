# frozen_string_literal: true

module Pedigree
  # Shared geometry (points) for the descendant chart, used by both the layout
  # (x positions) and the renderer (y positions and drawing).
  module Geom
    PORTRAIT_D  = 58   # portrait circle diameter
    CELL_W      = 66   # horizontal cell per portrait
    SPOUSE_GAP  = 34   # gap between a person and their spouse portrait
    SIBLING_GAP = 40   # gap between sibling family units
    LABEL_H     = 48   # space under a portrait for name + years
    NAME_GAP    = 10   # gap between a portrait and its name
    ROW_GAP     = 52   # vertical gap between generations
    MARGIN      = 44
    TITLE_H     = 56

    ROW_STEP = PORTRAIT_D + LABEL_H + ROW_GAP
  end
end

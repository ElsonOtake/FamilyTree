# frozen_string_literal: true

# The pedigree PDF uses Prawn's built-in AFM fonts with romaji (WinAnsi) names,
# which are sanitized in Pedigree::Pdf. Silence the informational m17n warning.
Prawn::Fonts::AFM.hide_m17n_warning = true

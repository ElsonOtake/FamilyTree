# frozen_string_literal: true

require 'tempfile'

module Pedigree
  # Produces circular PNG image data for a person's portrait: their avatar
  # masked to a circle when one is attached and readable, otherwise a shared
  # silhouette placeholder. All avatar handling is guarded so any storage or
  # image-processing failure quietly falls back to the silhouette.
  module Portrait
    SILHOUETTE_PATH = Rails.root.join('app/assets/images/silhouette.png')
    RENDER_SIZE = 220

    module_function

    # Binary PNG data for the person's circular portrait.
    def data_for(person)
      circular_avatar(person) || silhouette
    end

    def silhouette
      @silhouette ||= File.binread(SILHOUETTE_PATH)
    end

    def circular_avatar(person)
      return nil unless person.avatar.attached?

      src = write_tempfile(person.avatar.blob.download, extension(person))
      mask_to_circle(src.path)
    rescue StandardError
      nil
    ensure
      cleanup(src)
    end

    def mask_to_circle(src_path)
      out = Tempfile.create(['ped-out', '.png'])
      out.close
      size = RENDER_SIZE
      center = size / 2
      ok = system('magick', src_path,
                  '-resize', "#{size}x#{size}^", '-gravity', 'center', '-extent', "#{size}x#{size}",
                  '(', '-size', "#{size}x#{size}", 'xc:none', '-fill', 'white',
                  '-draw', "circle #{center},#{center} #{center},2", ')',
                  '-alpha', 'off', '-compose', 'CopyOpacity', '-composite', out.path,
                  out: File::NULL, err: File::NULL)
      ok && File.size?(out.path) ? File.binread(out.path) : nil
    ensure
      cleanup(out)
    end

    def write_tempfile(data, ext)
      file = Tempfile.create(['ped-src', ext])
      file.binmode
      file.write(data)
      file.flush
      file.close
      file
    end

    def extension(person)
      person.avatar.blob.filename.extension_with_delimiter.presence || '.img'
    end

    def cleanup(file)
      File.unlink(file.path) if file && File.exist?(file.path)
    rescue StandardError
      nil
    end
  end
end

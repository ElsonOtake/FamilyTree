# frozen_string_literal: true

require 'tempfile'

module Pedigree
  # Produces oval PNG image data for a person's portrait: their avatar cropped to
  # a vertical oval when one is attached and readable, otherwise a shared
  # silhouette placeholder centred on a white oval. All avatar handling is
  # guarded so any storage or image-processing failure quietly falls back to the
  # silhouette.
  module Portrait
    # Gender-specific silhouettes; any other gender ('P'/'X') or a missing one
    # falls back to the neutral silhouette.
    SILHOUETTE_PATHS = {
      'M' => Rails.root.join('app/assets/images/silhouette_male.png'),
      'F' => Rails.root.join('app/assets/images/silhouette_female.png')
    }.freeze
    DEFAULT_SILHOUETTE_PATH = Rails.root.join('app/assets/images/silhouette.png')
    RENDER_W = 220
    RENDER_H = 282

    module_function

    # Binary PNG data for the person's oval portrait.
    def data_for(person)
      oval_avatar(person) || silhouette(person.gender)
    end

    # Silhouette drawn on a white oval so it reads as a framed portrait; masked
    # to the oval so the frame's mat shows through the corners. Chosen by gender
    # and cached per source image.
    def silhouette(gender = nil)
      path = silhouette_path(gender)
      (@silhouettes ||= {})[path] ||= build_silhouette(path) || File.binread(path)
    end

    # Path to the silhouette for a gender, defaulting to the neutral one.
    def silhouette_path(gender)
      SILHOUETTE_PATHS.fetch(gender, DEFAULT_SILHOUETTE_PATH)
    end

    def oval_avatar(person)
      return nil unless person.avatar.attached?

      src = write_tempfile(person.avatar.blob.download, extension(person))
      mask_to_oval(src.path)
    rescue StandardError
      nil
    ensure
      cleanup(src)
    end

    # Resize an image to fill the oval and clip it to a vertical ellipse.
    def mask_to_oval(src_path)
      run_magick(
        src_path,
        '-resize', "#{RENDER_W}x#{RENDER_H}^", '-gravity', 'center', '-extent', "#{RENDER_W}x#{RENDER_H}",
        *ellipse_mask_args
      )
    end

    # A white oval carrying the silhouette centred at ~60% size.
    def build_silhouette(path)
      run_magick(
        '-size', "#{RENDER_W}x#{RENDER_H}", 'xc:white',
        '(', path.to_s, '-resize', "#{(RENDER_W * 0.62).round}x#{(RENDER_H * 0.62).round}", ')',
        '-gravity', 'center', '-composite',
        *ellipse_mask_args
      )
    end

    # Composited args that clip the current image to a full-frame ellipse.
    def ellipse_mask_args
      cx = RENDER_W / 2
      cy = RENDER_H / 2
      ['(', '-size', "#{RENDER_W}x#{RENDER_H}", 'xc:none', '-fill', 'white',
       '-draw', "ellipse #{cx},#{cy} #{cx - 1},#{cy - 1} 0,360", ')',
       '-alpha', 'off', '-compose', 'CopyOpacity', '-composite']
    end

    def run_magick(*args)
      out = Tempfile.create(['ped-out', '.png'])
      out.close
      ok = system('magick', *args, out.path, out: File::NULL, err: File::NULL)
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

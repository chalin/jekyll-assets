# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    class Default
      class Audio < Default
        content_types "audio/aiff"
        content_types "audio/basic"
        content_types "audio/mpeg"
        content_types "audio/midi"
        content_types "audio/wave"
        content_types "audio/mp4"
        content_types "audio/ogg"
        content_types "audio/flac"
        content_types "audio/aac"

        # --
        def set_src
          dpath = asset.digest_path
          return args[:src] = asset.url if asset.is_a?(Url)
          return args[:src] = env.prefix_url(dpath) unless args[:inline]
          # This is insanity, but who am I to judge you, and what you do.
          args[:src] = asset.data_uri
        end

        # --
        def set_controls
          return if args.key?(:controls)

          args[:controls] = true
          unless args.key?(:controlsList) || args.key?(:controlslist)
            args[:controlList] = "nodownload"
          end
        end

        # --
        def set_integrity
          return unless integrity?

          args[:integrity] = asset.integrity
          unless args.key?(:crossorigin)
            args[:crossorigin] = "anonymous"
          end
        end

        # --
        def integrity?
          config[:integrity] && !asset.is_a?(Url) &&
            !args.key?(:integrity)
        end
      end
    end
  end
end

# --
Jekyll::Assets::Hook.register :config, :before_merge do |c|
  c.deep_merge!({
    defaults: {
      audio: {
        integrity: Jekyll.production?,
      },
    },
  })
end
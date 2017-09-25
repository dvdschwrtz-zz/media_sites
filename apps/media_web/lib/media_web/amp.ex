defmodule MediaWeb.Amp do

  import Phoenix.HTML.Tag

  def img(:amp, src, _srcset_medium, _srcset_small, amp_height, amp_width, alt),
    do: tag(:'amp-img', src: src, height: amp_height, width: amp_width, alt: alt)

  def img(:html, src, srcset_medium, srcset_small, _amp_height, _amp_width, alt) do
    content_tag(:picture) do
      [
        tag(:source, srcset: srcset_small, media: "(max-width: 500px)"),
        tag(:source, srcset: srcset_medium, media: "(max-width: 1200px)"),
        img_tag(src, alt: alt)
      ]
    end
  end
end

class HTMLWithWell < Redcarpet::Render::HTML
  def postprocess(full_document)
    full_document
    .gsub(/<p>%%%(.+)%%%<\/p>/m) { |m|
      "<div class='well narrow'>#{m[6..-8]}</div>"
    }
    .gsub(/<p>%%(.+)%%<\/p>/m) { |m|
      "<div class='well'>#{m[5..-7]}</div>"
    }
    .gsub(/\^\^\^\^(.+)\^\^\^\^/) { |m|
      "<span class='lettrine level4'>#{m[4..-5]}</span>"
    }
    .gsub(/\^\^\^(.+)\^\^\^/) { |m|
      "<span class='lettrine level3'>#{m[3..-4]}</span>"
    }
    .gsub(/\^\^(.+)\^\^/) { |m|
      "<span class='lettrine level2'>#{m[2..-3]}</span>"
    }
    .gsub(/\^(.+)\^/) { |m|
      "<span class='lettrine level1'>#{m[1..-2]}</span>"
    }
  end
end

module MarkdownHelper
  def clean(text)
    TypographicCleaner.clean(text)
  end

  def markdown(text)
    renderer = HTMLWithWell.new(hard_wrap: true)
    m = Redcarpet::Markdown.new(renderer, strikethrough: true, tables: true)
    m.render(text || '').html_safe
  end
end

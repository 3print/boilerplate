class HTMLWithWell < Redcarpet::Render::HTML
  def postprocess(full_document)
    full_document = full_document
    .gsub(/<p>%%%(.+)%%%<\/p>/m) { |m|
      "<div class='well narrow'>#{m[6..-8]}</div>"
    }
    .gsub(/<p>%%(.+)%%<\/p>/m) { |m|
      "<div class='well'>#{m[5..-7]}</div>"
    }
    .gsub(/<p>--&gt;&gt;(.+)--&gt;&gt;<\/p>/m) { |m|
      "<div class='text-right'>#{m[13..-15]}</div>"
    }
    .gsub(/<p>&lt;&lt;--(.+)&lt;&lt;--<\/p>/m) { |m|
      "<div class='text-left'>#{m[13..-15]}</div>"
    }
    .gsub(/<p>-&gt;&lt;-(.+)-&gt;&lt;-<\/p>/m) { |m|
      "<div class='text-center'>#{m[13..-15]}</div>"
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
    .gsub(/%\(([^)]+)\)/) { |m|
      "<i class='fa fa-#{m[2..-2]}'></i>"
    }
    .gsub(/\((.+)=&gt;([^\)]+)\)/) { |m|
      a,b = m[1..-2].split('=&gt;')
      "<a class='btn btn-primary' href='#{b}'>#{a}</a>"
    }

    if full_document.scan(/<p>/).size == 1
      full_document = Regexp.new(/\A<p>(.*)<\/p>\Z/m).match(full_document)[1] rescue full_document
    end

    full_document
  end
end

module MarkdownHelper
  def clean(text)
    begin
      Timeout::timeout(2) do
        TypographicCleaner.clean(text)
      end
    rescue Timeout::Error
      text
    end
  end

  def markdown(text)
    renderer = HTMLWithWell.new(hard_wrap: true)
    m = Redcarpet::Markdown.new(renderer, strikethrough: true, tables: true)
    m.render(clean(text) || '').html_safe
  end
end

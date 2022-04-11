class HTMLWithWell < Redcarpet::Render::HTML
  def preprocess(full_document)
    full_document = full_document
    .gsub(/\((.+)=>([^\)]+)\)/) { |m|
      a,b = m[1..-2].split('=>')
      "<a class='btn btn-primary' href='#{b}'>#{a}</a>"
    }
    full_document
  end

  def postprocess(full_document)
    full_document = full_document
    .gsub(/<p>%%%(.+)%%%<\/p>/m) { |m|
      "<div class='border rounded p-1 mb-2'>#{m[6..-8]}</div>"
    }
    .gsub(/<p>%%(.+)%%<\/p>/m) { |m|
      "<div class='border rounded p-2 mb-2'>#{m[5..-7]}</div>"
    }
    .gsub(/<p>--&gt;&gt;(.+?)--&gt;&gt;<\/p>/m) { |m|
      "<div class='text-end'>#{m[13..-15]}</div>"
    }
    .gsub(/<p>&lt;&lt;--(.+?)&lt;&lt;--<\/p>/m) { |m|
      "<div class='text-start'>#{m[13..-15]}</div>"
    }
    .gsub(/<p>-&gt;&lt;-(.+?)-&gt;&lt;-<\/p>/m) { |m|
      "<div class='text-center'>#{m[13..-15]}</div>"
    }
    .gsub(/\^\^\^\^(.+)\^\^\^\^/) { |m|
      "<span class='dropcap dc-4'>#{m[4]}</span>#{m[5..-5]}"
    }
    .gsub(/\^\^\^(.+)\^\^\^/) { |m|
      "<span class='dropcap dc-3'>#{m[3]}</span>#{m[4..-4]}"
    }
    .gsub(/\^\^(.+)\^\^/) { |m|
      "<span class='dropcap dc-2'>#{m[2]}</span>#{m[3..-3]}"
    }
    .gsub(/\^(.+)\^/) { |m|
      "<span class='dropcap dc-1'>#{m[1]}</span>#{m[2..-2]}"
    }
    .gsub(/%\(([^)]+)\)/) { |m|
      Feather[m[2..-2]]
    }

    if full_document.scan(/<p>/).size == 1
      full_document = Regexp.new(/\A<p>(.*)<\/p>\Z/m).match(full_document)[1] rescue full_document
    end

    full_document
  end
end

module MarkdownHelper
  def markdown(text=nil, &blk)
    text = capture_haml(&blk) if text.nil? && block_given?
    renderer = HTMLWithWell.new(hard_wrap: true)
    m = Redcarpet::Markdown.new(renderer, {
      strikethrough: true,
      tables: true,
      no_intra_emphasis: true,
    })
    m.render(text).html_safe
  end
end

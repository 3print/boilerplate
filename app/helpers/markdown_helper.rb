module MarkdownHelper
  def markdown(text)
    m = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: true))
    m.render(text || '').html_safe
  end
end

module BemHelper
  attr_accessor :block, :elements

  def bem_block(name, type: :div, modifier: nil, attrs: {}, &block)
    self.block = name
    self.elements = []

    blk_class = bem_class(name, modifier: modifier)

    if attrs[:class].present?
      attrs[:class] += " #{blk_class}"
    else
      attrs[:class] = blk_class
    end

    content_tag(type, attrs, &block)
  end

  def bem_element(name, type: :div, modifier: nil, attrs: {}, &block)
    self.elements << name

    el_class = bem_class(self.block, elements: self.elements, modifier: modifier)

    if attrs[:class].present?
      attrs[:class] += " #{el_class}"
    else
      attrs[:class] = el_class
    end

    content_tag(type, attrs, &block)
  end

  def bem_element_class(name, modifier= nil)
    bem_class(self.block, elements: self.elements + [name], modifier: modifier)
  end

  protected
  def bem_class(block, elements: [], modifier: nil)
    [
      block,
      elements.map {|e| "__#{e}"},
      modifier.present? ? "--#{modifier}" : nil,
    ].compact.flatten.join('')
  end
end

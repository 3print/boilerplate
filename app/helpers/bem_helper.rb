module BemHelper
  attr_accessor :block_stack, :elements_stack, :initialized

  def bem_block(name, type: :div, modifier: nil, attrs: {}, &block)
    self.init

    self.block_stack << name
    self.elements_stack << []

    blk_class = bem_class(name, modifier: modifier)

    if attrs[:class].present?
      attrs[:class] += " #{blk_class}"
    else
      attrs[:class] = blk_class
    end

    res = content_tag(type, attrs, &block)

    self.block_stack.pop
    self.elements_stack.pop

    res
  end

  def bem_element(name, type: :div, modifier: nil, attrs: {}, &block)
    self.elements_stack.last << name

    el_class = bem_class(self.block_stack.last, elements: self.elements_stack.last, modifier: modifier)

    if attrs[:class].present?
      attrs[:class] += " #{el_class}"
    else
      attrs[:class] = el_class
    end

    res = content_tag(type, attrs, &block)

    res
  end

  def bem_element_class(name, modifier= nil)
    bem_class(self.block_stack.last, elements: self.elements_stack.last + [name], modifier: modifier)
  end

  protected
  def init()
    unless self.initialized
      self.block_stack = []
      self.elements_stack = []
      self.initialized = true
    end
  end

  def bem_class(block, elements: [], modifier: nil)
    [
      block,
      elements.map {|e| "__#{e}"},
      modifier.present? ? "--#{modifier}" : nil,
    ].compact.flatten.join('')
  end
end

module CarouselHelper
  def carousel collection, options={}
    if collection.size == 0
      return ''
    end
    render(partial: 'shared/carousel', locals: {items: collection, options: options}).to_s
  end
end

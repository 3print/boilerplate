class ActionDispatch::Routing::Mapper
  def toggle(base, options={})
    options[:prefix] = 'un'
    off = options.delete(:off) || "#{options[:prefix]}#{base}"

    put base
    put off
  end
end

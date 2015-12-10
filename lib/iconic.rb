class Iconic
  class << self
    def config
      yield self if block_given?
    end

    def set_default_icon(icon)
      @default_icon = icon
    end

    def set_icon(resource, icon)
      @icons ||= {}.with_indifferent_access

      @icons[resource] = icon
    end

    def get_icon(resource)
      @icons[resource] || @default_icon rescue nil
    end
  end
end

module Feather
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

    def icon_name_for(resource)
      name = @icons[resource] || @default_icon
      name = @default_icon if !exists?(name)
      name
    end

    def get_icon(resource)
      name = @icons[resource] || @default_icon
      name = @default_icon if !exists?(name)

      transform_svg(name, FEATHER_SVGS[name])
    end

    def transform_svg(name, src)
      "<svg class='feather feather-#{name}' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'>#{src}</svg>".html_safe
    end

    def []= (resource, icon)
      set_icon resource, icon
    end

    def [] (name)
      name = @default_icon if !exists?(name)
      transform_svg(name, FEATHER_SVGS[name])
    end

    def exists?(icon)
      FEATHER_SVGS.has_key?(icon)
    end
  end
end

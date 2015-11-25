class Dashboard
  def self.add klass, options={}
    TPrint.debug "Adding #{klass.name} to dashboard"
    options.symbolize_keys!
    weight = options[:weight] || 0
    self.items[weight] ||= []
    self.items[weight] << [klass, options]
  end

  def self.items
    @items ||= []
    @items
  end

  def self.weighed_items
    self.items.flatten(1).compact
  end

end

require 'dashboard/railtie'

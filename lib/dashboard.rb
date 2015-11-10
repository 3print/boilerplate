class Dashboard
  def self.add klass, options={}
    TPrint.debug "Adding #{klass.name} to dashboard"
    options.symbolize_keys!
    self.items[klass] = options[:weight] || 1
  end

  def self.items
    @items ||= {}
    @items
  end
end

require 'dashboard/railtie'

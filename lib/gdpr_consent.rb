module GdprConsent
  def self.add_script(type, **params)
    @scripts ||= {}.with_indifferent_access
    @scripts[type] ||= []

    @scripts[type] << params
  end

  def self.get_all_scripts
    @scripts || {}
  end

  def self.get_scripts(type)
    @scripts ? @scripts[type] : nil
  end

  def self.[]= (type, name)
    self.add_script type, name
  end

  def self.[] (type)
    self.get_scripts(type)
  end

  def self.configure(&block)
    block.(self)
  end
end

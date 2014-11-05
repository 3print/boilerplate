module I18n
  def self.tc(key, params={})
    'label_with_colon'.t label: key.t(params)
  end

  def self.tp(key, params={})
    "prefix.#{key}".t(label: key.t(params))
  end
end

class Symbol
  def t(params={})
    I18n.t(self, params)
  end

  def tc(params={})
    I18n.tc(self, params)
  end
end

class String
  def t(params={})
    I18n.t(self.to_s, params)
  end

  def tc(params={})
    I18n.tc(self, params)
  end
end

class Time
  def l(params={})
    I18n.l(self, params)
  end
end

class DateTime
  def l(params={})
    I18n.l(self, params)
  end
end

class Date
  def l(params={})
    I18n.l(self, params)
  end
end

class ActiveRecord::Base
  def self.t
    "models.#{model_name.to_s.underscore.gsub('/', '_').pluralize}".t
  end

  def self.tp(params={})
    key = "models.#{model_name.to_s.underscore.gsub('/', '_')}"
    I18n.tp(key, params)
  end

  def tc(params={})
    I18n.tc(self, params)
  end

end

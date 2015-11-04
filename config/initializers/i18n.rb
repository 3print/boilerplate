module I18n
  def self.tc(key, params={})
    self.t('label_with_colon', label: key.t(params)).html_safe
  end

  def self.tp(key, params={})
    self.t("prefix.#{key}", label: key.t(params)).html_safe
  end

  def self.tmf(key, params={})
    model, col = key.split "."
    begin
      self.t "models.fields.#{key}", {raise: true}.update(params)
    rescue
      begin
        self.t "models.fields.common.#{col}", {raise: true}.update(params)
      rescue
        "models.fields.#{key}".t params
      end
    end
  end

  def self.tmfc(key, params={})
    self.t('label_with_colon', label: self.tmf(key, params)).html_safe
  end

  def self.t_with_default(key, params={})
    begin
      self.t(key, {raise: true}.update(params))
    rescue
      if Rails.env.development?
        "<span class='label label-danger' title='#{self.t(key, params)}'>!</span>#{key.split('.').last}".html_safe
      else
        key.split('.').last
      end
    end
  end
end

class Symbol
  def t(params={})
    I18n.t_with_default(self, params)
  end

  def tc(params={})
    I18n.tc(self, params)
  end

  def tmf(params={})
    I18n.tmf(self, params)
  end

  def tmfc(params={})
    I18n.tmfc(self, params)
  end
end

class String
  def t(params={})
    I18n.t_with_default(self.to_s, params)
  end

  def tc(params={})
    I18n.tc(self, params)
  end

  def tmf(params={})
    I18n.tmf(self, params)
  end

  def tmfc(params={})
    I18n.tmfc(self, params)
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

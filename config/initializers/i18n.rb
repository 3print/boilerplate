module I18n
  class << self
    def translate_with_fallback key, options={}, original=nil
      begin
        self.translate_without_fallback(key, {raise: true}.update(options))
      rescue => e
        split = key.to_s.split('.')
        if split.size <= 2
          translate_without_fallback original || key, options
        else
          v = split.pop
          v2 = split.pop
          split.pop if v2 == "default"
          split << "default" << v
          new_key = split.join('.')
          translate_with_fallback new_key, options, original || key
        end
      end
    end
    alias_method_chain :translate, :fallback
    alias_method :t, :translate
  end

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

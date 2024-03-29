module ToggleAttributes
  extend ActiveSupport::Concern

  included do
    def self.attr_toggle(name, options={})
      options[:prefix] ||= 'un'

      past_tense = name.to_s.verb.conjugate tense: :past, aspect: :perfective
      off_past_tense = options[:off] || "#{options[:prefix]}#{past_tense}"
      off = options.delete(:off) || "#{options[:prefix]}#{name}"

      bool_attribute = :"#{past_tense}?"
      target_attribute = options.delete(:for) || "#{past_tense}_at"
      target_set_attribute = :"#{target_attribute}="

      define_method name do
        send(target_set_attribute, Time.now)
        res = save
        send "after_#{name}" if respond_to?("after_#{name}")
        res
      end

      define_method off do
        send(target_set_attribute, nil)
        res = save
        send "after_#{off}" if respond_to?("after_#{off}")
        res
      end

      define_method bool_attribute do
        send(target_attribute).present?
      end

      scope :"#{past_tense}", ->() { where("#{table_name}.#{target_attribute} IS NOT NULL") }
      scope :"#{off_past_tense}", ->() { where("#{table_name}.#{target_attribute} IS NULL") }
    end
  end
end

require 'active_support/concern'

module DateTimeExtensions
  extend ActiveSupport::Concern

  included do
    def self.process_date_params
      before_action do
        self.process_date_params params
      end
    end

  end

  def process_date_params(params)
    params.keys.each do |key|
      if /__date$/ =~ key.to_s
        attr_name = key.to_s.gsub(/__date$/, '')
        date_value = params[key]
        time_value = params["#{attr_name}__time"]
        offset_value = params["#{attr_name}__offset"]

        params.delete(key)
        params.delete("#{attr_name}__time")
        params.delete("#{attr_name}__offset")
        params[attr_name] = "#{date_value}T#{time_value}:00+#{offset_value}"
      end

      if params[key].is_a?(ActionController::Parameters)
        process_date_params params[key]
      end
    end
  end
end

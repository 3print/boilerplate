require 'active_support/concern'

module RegionsExtensions
  extend ActiveSupport::Concern

  included do
    def self.process_regions_params
      before_action do
        self.process_regions_params params
      end
    end

  end

  def process_regions_params(params)
    params.keys.each do |key|
      if /_regions$/ =~ key.to_s
        params[key] = params[key].keys.map do |k|
          [k, params[key][k].blank? ? nil : JSON.parse(params[key][k])]
        end.to_h
      end

      if params[key].is_a?(ActionController::Parameters)
        process_regions_params params[key]
      end
    end
  end
end

require 'active_support/concern'

module ToggleExtensions
  extend ActiveSupport::Concern

  included do
    def self.toggle_actions(base, options={})
      options[:prefix] ||= 'un'

      off = options.delete(:off) || "#{options[:prefix]}#{base}"
      past_tense = base.verb.conjugate tense: :past, aspect: :perfective
      bool_attr = :"#{past_tense}?"

      define_method base do
        referer = request.referer

        unless resource.send(bool_attr)
          if resource.send(base)
            redirect_to referer
          else
            p resource, resource.errors
            flash[:error] = 'errors.toggle'.t
            redirect_to referer
          end
        else
          redirect_to referer
        end
      end

      define_method off do
        referer = request.referer

        if resource.send(bool_attr)
          if resource.send(off)
            redirect_to referer
          else
            p resource, resource.errors
            flash[:error] = 'errors.toggle'.t
            redirect_to referer
          end
        else
          redirect_to referer
        end
      end
    end
  end
end

require 'active_support/concern'

module PDFController
  extend ActiveSupport::Concern

  included do
    def self.pdf_controller name, options={}
      define_method name do
        opts = {
          pdf: options[:pdf_name].to_s || name.to_s,
          template: options[:template] || "#{self.class.resource_name}/#{name}",
          layout: options[:layout] || 'layouts/pdf',
          formats: :pdf,
          encoding: 'utf-8',
          dpi: options[:dpi] || 150,
          orientation: options[:orientation] || 'Portrait',
          margin: options[:margin] || {
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
          },
        }
        @format = :pdf
        unless params[:format].to_s == 'pdf'
          opts.merge! show_as_html: true
          @format = :html
        end

        render opts
      end
    end
  end
end

require 'active_support/concern'

module OrderableExtensions
  extend ActiveSupport::Concern

  def save_sequence
    begin
      sequences = params.require(resource_name).permit!

      resource_class.update_items_sequences(sequences)

      redirect_to [controller.controller_namespace, resource_class].flatten
    rescue => e
      render 'index', status: 422
    end
  end
end

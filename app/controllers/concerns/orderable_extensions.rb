require 'active_support/concern'

module OrderableExtensions
  extend ActiveSupport::Concern

  def save_sequence
    begin
      sequences = params[resource_name]

      resource_class.update_items_sequences(sequences)

      redirect_to [:admin, resource_class]
    rescue => e
      render 'index', status: 422
    end
  end
end

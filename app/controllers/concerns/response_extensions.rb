require 'active_support/concern'

module ResponseExtensions
  extend ActiveSupport::Concern

  def success_response
    case action_name
    when 'create' then success_message_for_create
    when 'update' then success_message_for_update
    end

    super
  end

  def success_message_for_create
    if request.format.html?
      msg = 'messages.success.create'.t(model: resource_class.tp)
      msg += render_to_string partial: 'shared/messages', locals: {url_index: resource_path(:index), url_new: resource_path(:new)}
      flash[:notice] = msg
    end
  end

  def success_message_for_update
    if request.format.html?
      flash[:notice] = 'messages.success.update'.t(model: resource_class.tp)
    end
  end

end

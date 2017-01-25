module NotificationExtensions
  extend ActiveSupport::Concern

  if ENV["SLACK_WEBHOOK_URL"].present?
    included do
      before_action :set_notification

      def set_notification
        request.env['exception_notifier.exception_data'] = {
          "user-agent" => request.user_agent,
          "domain-name" => request.host,
        }
         # can be any key-value pairs
      end
    end
  end
end

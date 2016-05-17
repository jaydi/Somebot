class WebMessageHandlingJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    wm = WebMessage.find(id)
    wm.process_message
  end
end

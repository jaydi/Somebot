class WebMessagesController < ApplicationController

  def index
  end

  def inbound
    # action_type = params["type"]
    wm = WebMessage.new(web_message_params)
    if wm.save!
      WebMessageHandlingJob.perform_later(wm.id)

      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 500
    end
  end

  private

  def web_message_params
    permitted_params = {}
    permitted_params.merge!(params.permit({message: [:msg_id, :msg_type, :user_key, :chat_key, :text]})['message'])
    permitted_params.merge!({'bound' => :inbound})
    permitted_params
  end

end

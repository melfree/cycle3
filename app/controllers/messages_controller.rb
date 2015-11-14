class MessagesController < ApplicationController
  
  def create
    message = Message.new(message_params)
    message.deal_id = current_user.current_deal.id
    message.user_id = current_user.id
    if !message.content.blank?
      message.save!
    end
  end

  private
  def message_params
    params.required(:message).permit(:content)
  end
end

class EmailsController < ApplicationController
  def send
    message_params = params.permit(:to, :to_name, :from, :from_name, :subject, :body)
    message = Message.new(message_params)
    if message.valid?
      message.deliver
      head(:ok)
    else
      head(:bad_request)
    end
  end
end

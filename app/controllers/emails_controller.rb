class EmailsController < ApplicationController
  def deliver
    message_params = params.permit(:to, :to_name, :from, :from_name, :subject, :body)
    message = Message.new(message_params)
    if message.valid?
      message.deliver
      head(:ok)
    else
      render(json: { errors: message.errors.full_messages }, status: :bad_request)
    end
  end
end

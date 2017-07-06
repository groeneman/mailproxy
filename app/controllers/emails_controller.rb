class EmailsController < ApplicationController
  def deliver
    message_params = params.permit(:to, :to_name, :from, :from_name, :subject, :body)
    message = Message.new(message_params)

    if message.invalid?
      render(json: { errors: message.errors.full_messages }, status: :bad_request)
      return
    end

    mailer = message.mailer
    mailer.call

    if mailer.ok?
      head(:ok)
    else
      render(json: { errors: mailer.errors }, status:	:internal_server_error)
    end
  end
end

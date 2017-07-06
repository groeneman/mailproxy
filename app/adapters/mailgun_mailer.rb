# Mailgun API docs: https://documentation.mailgun.com/en/latest/quickstart-sending.html#send-via-api
class MailgunMailer
  attr_reader :message

  def initialize(message)
    @message = message
    @response = nil
  end

  def call
    begin
      @response = RestClient.post(Rails.application.secrets.mailgun_endpoint, {
        from: "#{ message.from_name } <#{ message.from }>",
        to: "#{ message.to_name } <#{ message.to }>",
        subject: message.subject,
        text: message.sanitized_body
      })
    rescue RestClient::ExceptionWithResponse => e
      @response = e.response
    end
  end

  def ok?
    @response&.code == 200
  end

  def errors
    [JSON.parse(@response.body)['message']]
  end
end

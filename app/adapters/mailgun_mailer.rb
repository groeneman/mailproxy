# Mailgun API docs: https://documentation.mailgun.com/en/latest/quickstart-sending.html#send-via-api
module MailgunMailer
  def self.call(message)
    begin
      RestClient.post(Rails.application.secrets.mailgun_endpoint, {
        from: "#{ message.from_name } <#{ message.from }>",
        to: "#{ message.to_name } <#{ message.to }>",
        subject: message.subject,
        text: message.sanitized_body
      })
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end
end

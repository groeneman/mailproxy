# SendGrid API docs: https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html
module SendgridMailer
  API_ENDPOINT = 'https://api.sendgrid.com/v3/mail/send'

  def self.call(message)
    body = {
      personalizations: [
        {
          to: [{ email: message.to, name: message.to_name }],
          subject: message.subject
        }
      ],
      from: { email: message.from, name: message.from_name },
      content: [{ type: 'text/plain', value: message.sanitized_body }]
    }

    begin
      RestClient.post(API_ENDPOINT, body.to_json, headers)
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end

  private

  def self.headers
    {
      Authorization: "Bearer #{ Rails.application.secrets.sendgrid_api_key }",
      'Content-Type': 'application/json'
    }
  end
end

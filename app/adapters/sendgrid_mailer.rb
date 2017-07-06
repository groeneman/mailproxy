# SendGrid API docs: https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html
class SendgridMailer
  API_ENDPOINT = 'https://api.sendgrid.com/v3/mail/send'

  attr_reader :message

  def initialize(message)
    @message = message
  end

  def call
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
      @response = RestClient.post(API_ENDPOINT, body.to_json, headers)
    rescue RestClient::ExceptionWithResponse => e
      @response = e.response
    end
  end

  def ok?
    @response&.code < 300
  end

  def errors
    JSON.parse(@response.body)['errors'].map { |e| e['message'] }
  end

  private

  def headers
    {
      Authorization: "Bearer #{ Rails.application.secrets.sendgrid_api_key }",
      'Content-Type': 'application/json'
    }
  end
end

describe MailgunMailer do
  let(:message) do
    Message.new({
      to: 'michael@groeneman.com',
      to_name: 'Michael Groeneman',
      from: 'bob@groeneman.com',
      from_name: 'Bob Groeneman',
      subject: 'Hi Michael',
      body: 'This is some content for Michael Groeneman'
    })
  end

  it 'makes a POST request to the sendgrid API endpoint' do
    endpoint = Rails.application.secrets.mailgun_endpoint
    expect(RestClient).to receive(:post).with(endpoint, anything)
    described_class.call(message)
  end

  it 'sends the correct API parameters' do
    params = {
      from: "#{ message.from_name } <#{ message.from }>",
      to: "#{ message.to_name } <#{ message.to }>",
      subject: message.subject,
      text: message.sanitized_body
    }

    expect(RestClient).to receive(:post).with(anything, params)
    described_class.call(message)
  end
end

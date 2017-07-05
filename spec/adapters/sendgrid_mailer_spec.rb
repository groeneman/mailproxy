describe SendgridMailer do
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
    expect(RestClient)
      .to receive(:post).with(described_class::API_ENDPOINT, anything, anything)

    described_class.call(message)
  end

  it 'includes the appropriate headers for the Sendgrid API' do
    headers = {
      Authorization: "Bearer #{ Rails.application.secrets.sendgrid_api_key }",
      'Content-Type': 'application/json'
    }

    expect(RestClient).to receive(:post).with(anything, anything, headers)
    described_class.call(message)
  end

  it 'sends the correct API parameters' do
    params = {
      personalizations: [
        { to: [{ email: message.to, name: message.to_name }], subject: message.subject }
      ],
      from: { email: message.from, name: message.from_name },
      content: [{ type: 'text/plain', value: message.sanitized_body }]
    }

    expect(RestClient).to receive(:post).with(anything, params.to_json, anything)
    described_class.call(message)
  end
end

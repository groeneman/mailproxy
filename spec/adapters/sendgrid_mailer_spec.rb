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

  subject { described_class.new(message) }

  let(:ok_response) do
    instance_double(RestClient::Response, code: 200)
  end

  let(:error_response) do
    instance_double(RestClient::Response,
      code: 400,
      body: { errors: [{ message: 'An error of some sort' }] }.to_json
    )
  end

  let(:exception) { RestClient::ExceptionWithResponse.new(error_response) }

  it 'makes a POST request to the sendgrid API endpoint' do
    expect(RestClient)
      .to receive(:post).with(described_class::API_ENDPOINT, anything, anything)

    subject.call
  end

  it 'includes the appropriate headers for the Sendgrid API' do
    headers = {
      Authorization: "Bearer #{ Rails.application.secrets.sendgrid_api_key }",
      'Content-Type': 'application/json'
    }

    expect(RestClient).to receive(:post).with(anything, anything, headers)
    subject.call
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
    subject.call
  end

  it 'returns true for #ok? after a successful send' do
    allow(RestClient).to receive(:post).and_return(ok_response)
    subject.call
    expect(subject).to be_ok
  end

  it 'returns false for #ok? when an error is returned by the gateway' do
    allow(RestClient).to receive(:post).and_raise(exception)
    subject.call
    expect(subject).not_to be_ok
  end

  it 'returns an array of errors  when an error is returned by the gateway' do
    allow(RestClient).to receive(:post).and_raise(exception)
    subject.call
    expect(subject.errors).to eq(['An error of some sort'])
  end

end

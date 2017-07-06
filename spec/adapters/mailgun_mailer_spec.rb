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

  subject { described_class.new(message) }

  let(:ok_response) do
    instance_double(RestClient::Response, code: 200)
  end

  let(:error_response) do
    instance_double(RestClient::Response,
      code: 400,
      body: { message: 'An error of some sort' }.to_json
    )
  end

  let(:exception) { RestClient::ExceptionWithResponse.new(error_response) }

  it 'makes a POST request to the sendgrid API endpoint' do
    endpoint = Rails.application.secrets.mailgun_endpoint
    expect(RestClient).to receive(:post).with(endpoint, anything)
    subject.call
  end

  it 'sends the correct API parameters' do
    params = {
      from: "#{ message.from_name } <#{ message.from }>",
      to: "#{ message.to_name } <#{ message.to }>",
      subject: message.subject,
      text: message.sanitized_body
    }

    expect(RestClient).to receive(:post).with(anything, params)
    subject.call
  end

  it 'returns true for #ok? after a successful call' do
    allow(RestClient).to receive(:post).and_return(ok_response)
    subject.call

    expect(subject).to be_ok
  end

  it 'returns false for #ok? when an error is returned by the gateway' do
    allow(RestClient).to receive(:post).and_raise(exception)
    subject.call

    expect(subject).not_to be_ok
  end

  it 'returns an array of #errors when an error is returned by the gateway' do
    allow(RestClient).to receive(:post).and_raise(exception)
    subject.call

    expect(subject.errors).to eq(['An error of some sort'])
  end

end

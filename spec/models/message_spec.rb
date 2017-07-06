describe Message do
  it { should validate_presence_of(:to_name) }
  it { should validate_presence_of(:from_name) }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }

  it { should allow_value('michael@groeneman.com').for(:to) }
  it { should allow_value('michael@groeneman.com').for(:from) }

  it { should_not allow_value('notanemail').for(:to) }
  it { should_not allow_value('notanemail').for(:from) }

  describe '#sanitized_body' do
    subject { described_class.new(body: '<b>HTML in the body</b>') }

    it 'returns the body as plain text' do
      expect(subject.sanitized_body).to eq('HTML in the body')
    end
  end

  describe '#mailer' do
    it 'returns a mailer object ready to deliver the message' do
      expect(subject.mailer)
        .to be_an_instance_of(Rails.configuration.default_mail_gateway)
    end
  end
end

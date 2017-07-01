describe Message do
  it { should validate_presence_of(:to_name) }
  it { should validate_presence_of(:from_name) }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }

  it { should allow_value('michael@groeneman.com').for(:to) }
  it { should allow_value('michael@groeneman.com').for(:from) }

  it { should_not allow_value('notanemail').for(:to) }
  it { should_not allow_value('notanemail').for(:from) }
end

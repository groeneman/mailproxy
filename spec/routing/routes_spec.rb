describe 'Routes' do
  it 'routes /email to the emails controller\'s send action' do
    expect(post: '/email').to route_to(controller: 'emails', action: 'deliver')
  end
end

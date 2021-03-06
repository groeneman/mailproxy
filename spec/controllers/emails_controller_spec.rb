describe EmailsController do
  describe 'POST: #send' do
    it 'responds with bad_request when invalid parameters are passed' do
      post(:deliver)
      expect(response).to have_http_status(:bad_request)
    end

    it 'responds with ok with no body when valid parameters are passed' do
      post(:deliver, params: {
        to: 'michael@groeneman.com',
        to_name: 'Michael Groeneman',
        from: 'bob@groeneman.com',
        from_name: 'Bob Groeneman',
        subject: 'Hi Michael',
        body: 'This is some content for Michael Groeneman'
      })

      expect(response).to have_http_status(:ok)
    end
  end
end

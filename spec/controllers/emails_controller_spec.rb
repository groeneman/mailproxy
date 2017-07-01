describe EmailsController do
  describe 'POST: #send' do
    it 'renders bad request when invalid parameters are passed' do
      post(:send)
      expect(response).to have_http_status(:bad_request)
    end

    it 'renders bad request when invalid parameters are passed' do
      post(:send, params: {
        to: 'nottimcook@notapple.com',
        to_name: 'Tim Cook',
        from: 'michael@groeneman.com',
        from_name: 'Michael Groeneman',
        subject: 'Hi Tim',
        body: 'This is some content for Tim Cook'
      })

      expect(response).to have_http_status(:ok)
    end
  end
end

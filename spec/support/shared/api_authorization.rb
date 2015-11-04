shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(request_method, path)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(request_method, path, access_token: '1234')
      expect(response.status).to eq 401
    end
  end

  # context 'authorized' do
  #   before { do_request(path, request_method, access_token: access_token.token) }
  #
  #   it 'returns 200 status code' do
  #     expect(response).to be_success
  #   end
  # end
end

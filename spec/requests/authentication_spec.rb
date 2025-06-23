require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe 'POST /authenticate' do
    let(:user) { FactoryBot.create(:user, username: 'user1', password: 'password1') }

    it 'authenticates a user with valid credentials' do
      post '/api/v1/authenticate', params: { username: user.username, password: 'password1' }

      expect(response).to have_http_status(:ok)

      expect(JSON.parse(response.body)).to eq(
        {
          'token' => 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w'
        }
      )
    end

    it 'returns error when password is missing' do
      post '/api/v1/authenticate', params: { username: user.username }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Missing password' })
    end

    it 'returns error when password is incorrect' do
      post '/api/v1/authenticate', params: { username: user.username, password: 'wrongpassword' }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid username or password' })
    end
  end
end

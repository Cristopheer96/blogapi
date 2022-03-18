require 'rails_helper'

RSpec.describe 'Health endpoint', type: :request do
  describe 'GET /health' do # es descriptivo no codea nada
    before { get '/health'}

    it 'should return Ok' do #las pruebas en rspec comienznas con it
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload['api']).to eq('OK')

    end

    it 'should return status code 200' do #las pruebas en rspec comienznas con it
      expect(response).to have_http_status(200)
    end

  end
end

require 'rails_helper'

RSpec.describe 'Coaches', type: :request do
  let!(:coaches) { create_list(:coach, 2) }
  let(:response_body) { JSON.parse(response.body) }
  let(:response_attributes) { response_body['data']['attributes'] }

  # Test suite for GET /coaches
  describe 'GET /coaches' do
    before { get '/coaches' }

    it 'returns coaches' do
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  # Test suite for POST /coach
  describe 'POST /coaches' do
    headers = { 'Accept' => 'application/vnd.api+json',
                'Content-Type' => 'application/vnd.api+json' }
    valid_name = Faker::Name.name
    valid_params = { "data": { "type": 'coaches', "attributes": { "name": valid_name } } }.to_json
    invalid_params = { "data": { "type": 'coaches', "attributes": { "name": '' } } }.to_json

    context 'when the request is valid' do
      before { post '/coaches', params: valid_params, headers: headers }

      it 'creates a coach' do
        expect(response_attributes['name']).to eq(valid_name)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      before { post '/coaches', params: invalid_params, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response_body['errors'][0]['detail'])
          .to include("name - can't be blank")
      end
    end
  end

  # Test suite for PUT /coach
  describe 'PATCH /coaches' do
    let!(:coach1) { coaches.first }

    headers = { 'Accept' => 'application/vnd.api+json',
                'Content-Type' => 'application/vnd.api+json' }
    context 'when the request is valid' do
      new_name = 'NEW NAME'
      before do
        patch "/coaches/#{coach1.id}",
              params: { "data": {
                "type": 'coaches',
                "id": coach1.id,
                "attributes": { "name": new_name }
              } }.to_json,
              headers: headers
      end

      it 'update a coach' do
        expect(response_attributes['name']).to eq(new_name)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the request is invalid' do
      before do
        patch "/coaches/#{coach1.id}",
              params: { "data": {
                "type": 'coaches',
                "id": coach1.id,
                "attributes": { "name": '' }
              } }.to_json,
              headers: headers
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response_body['errors'][0]['detail'])
          .to include("name - can't be blank")
      end
    end
  end

  # Test suite for DELETE /coach/:id
  describe 'DELETE /coaches/:id' do
    headers = { 'Accept' => 'application/vnd.api+json',
                'Content-Type' => 'application/vnd.api+json' }

    context 'when the request is valid and no associated course' do
      let!(:coach1) { coaches.first }

      before { delete "/coaches/#{coach1.id}", headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the coach has assocated course' do
      let!(:coach1) { coaches.first }
      let!(:course) { create(:course, coach: coach1) }

      before { delete "/coaches/#{coach1.id}", headers: headers }

      it 'deletes the coach and transfer the course to another coach' do
        message = 'successfully deleted the coach and tranfered the course'
        expect(response_body['message']).to eq(message)
      end
    end

    context 'when the coach has assocated course and no coach availability to transfer' do
      let!(:coach1) { coaches.first }
      let!(:coach2) { coaches.last }
      let!(:course1) { create(:course, coach: coach1) }
      let!(:course2) { create(:course, coach: coach2) }

      before { delete "/coaches/#{coach1.id}", headers: headers }

      it 'deletes the coach and transfer the course to another coach' do
        message = 'The currect coach course is not tranferable'
        expect(response_body['message']).to eq(message)
      end
    end
  end
end

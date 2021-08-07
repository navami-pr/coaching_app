require 'rails_helper'

RSpec.describe 'Activities', type: :request do
  let!(:activities) { create_list(:activity, 10) }
  let!(:coach) { create(:coach) }
  let!(:course) { create(:course, coach: coach) }
  let(:activity) { activities.first }
  let(:response_body) { JSON.parse(response.body) }
  let(:response_attributes) { response_body['data']['attributes'] }

  # Test suite for GET /activities
  describe 'GET /activities' do
    before { get '/activities' }

    it 'returns activities' do
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  # Test suite for PUT /activity
  describe 'PATCH /activities' do
    let(:activity) { activities.first }

    headers = { 'Accept' => 'application/vnd.api+json',
                'Content-Type' => 'application/vnd.api+json' }
    context 'when the request is valid' do
      new_name = 'NEW NAME'
      before do
        patch "/activities/#{activity.id}",
              params: { "data": {
                "type": 'activities',
                "id": activity.id,
                "attributes": { "name": new_name }
              } }.to_json,
              headers: headers
      end

      it 'update a activity' do
        expect(response_attributes['name']).to eq(new_name)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the request is invalid' do
      before do
        patch "/activities/#{activity.id}",
              params: { "data": {
                "type": 'activities',
                "id": activity.id,
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

  # Test suite for DELETE /activity/:id
  describe 'DELETE /activities/:id' do
    headers = { 'Accept' => 'application/vnd.api+json',
                'Content-Type' => 'application/vnd.api+json' }

    context 'when the request is valid' do
      before { delete "/activities/#{activity.id}", headers: headers }

      it 'returns status code 200' do
        expect(Activity.all.count).to eq activities.count - 1
      end
    end

    context 'when the record is not present' do
      before { delete '/activities/100', headers: headers }

      it 'shouls return status code 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

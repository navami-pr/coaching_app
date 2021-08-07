require 'rails_helper'

RSpec.describe 'Courses', type: :request do
  let!(:courses) { create_list(:course, 10) }
  let!(:coach) { create(:coach) }
  let!(:course) { create(:course, coach: coach) }
  let(:response_body) { JSON.parse(response.body) }
  let(:response_attributes) { response_body['data']['attributes'] }

  # Test suite for GET /courses
  describe 'GET /courses' do
    before { get '/courses' }

    it 'returns courses' do
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  # Test suite for PUT /course
  describe 'PATCH /courses' do
    headers = { 'Accept' => 'application/vnd.api+json',
                'Content-Type' => 'application/vnd.api+json' }
    context 'when the request is valid' do
      new_name = 'NEW NAME'
      before do
        patch "/courses/#{course.id}",
              params: { "data": {
                "type": 'courses',
                "id": course.id,
                "attributes": { "name": new_name }
              } }.to_json,
              headers: headers
      end

      it 'update a course' do
        expect(response_attributes['name']).to eq(new_name)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the request is invalid' do
      before do
        patch "/courses/#{course.id}",
              params: { "data": {
                "type": 'courses',
                "id": course.id,
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

  # Test suite for DELETE /course/:id
  describe 'DELETE /courses/:id' do
    headers = { 'Accept' => 'application/vnd.api+json',
                'Content-Type' => 'application/vnd.api+json' }

    context 'when the request is valid' do
      before { delete "/courses/#{course.id}", headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the record is not present' do
      before { delete '/courses/100', headers: headers }

      it 'shouls return status code 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

require 'rails_helper'
require 'byebug'

RSpec.describe 'Posts with authentication ', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:user_post) { create(:post, user_id: user.id) }
  let!(:other_user_post) { create(:post, user_id: other_user.id, published: true) }
  let!(:other_user_post_draft) { create(:post, user_id: other_user.id, published: false) }

  let!(:auth_headers) { {'Authorizacion' => "Bearer #{user.auth_token}"} }
  let!(:other_auth_headers) { {'Authorizacion' => "Bearer #{other_user.auth_token}"} }


    #request con authenticatin en http hay un header adicional donde se espepcifica el token
  # asi esl header para enviar token de autorizacion  => "Authorization: Bearer xxxx"


   describe 'GET /post' do # es descriptivo no codea nada

    describe 'GET /post/{id} 'do
      context 'with authentication valid'do
        context 'when requisting other author post'do
          context 'when post is public'do
            before { get "/posts/#{other_user_post.id}", headers: auth_headers }
            #pay load
            context 'pay load' do
              subject { JSON.parse(response.body) }
              it { is_expected.to include(:id)}
            end
            context 'response' do
              subject { response}
              it { is_expected.to have_http_status(:ok)}
            end
            #reponse
          end
          context 'when post is not public' do
            before { get "/posts/#{other_user_post_draft.id}", headers: auth_headers }
            #pay load
            context 'pay load' do
              subject { JSON.parse(response.body) }
              it { is_expected.to include(:error)}
            end
            context 'response' do
              subject { response}
              it { is_expected.to have_http_status(:not_found) }
            end
          end
        end
        context 'when requisiting user post'do

        end
      end
    end

    describe 'GET /post/{id} 'do

    end

    describe 'GET /post/{id} 'do

    end
  end

end

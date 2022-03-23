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
      context 'With authentication valid.'do
        context 'When requisting other author post.'do
          context 'When post is public.'do
            before { get "/posts/#{other_user_post.id}", headers: auth_headers }
            #pay load
            context 'Pay load.' do
              subject { payload }
              it { is_expected.to include(:id)}
            end
            context 'Response.' do
              subject { response}
              it { is_expected.to have_http_status(:ok)}
            end
            #reponse
          end
          context 'When post is not public.' do
            before { get "/posts/#{other_user_post_draft.id}", headers: auth_headers }
            #pay load
            context 'Pay load.' do
              subject { payload }
              it { is_expected.to include(:error)}
            end
            context 'Response' do
              subject { response }
              it { is_expected.to have_http_status(:not_found) }
            end
          end
        end
        context 'When requisiting user post'do

        end
      end
    end

    describe 'POST /post/{id} 'do
      #con authentication se pued crear
      #sin authtentacation no se puede crear

    end

    describe 'PUT /post/{id} 'do
      # con auth  :
        #actualizar un post nuestro
        # no se puede actualizar un poso de otro : 401
      # sin authentication no se podra actualizar
    end
  end

  private

  def payload
    JSON.parse(response.body).with_indifferent_access
  end

end

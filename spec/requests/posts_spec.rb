require 'rails_helper'
require 'byebug'

RSpec.describe 'Posts ', type: :request do
  describe 'GET /post' do # es descriptivo no codea nada

    it 'should return Ok' do #las pruebas en rspec comienznas con it
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end
    describe "Search" do
      let!(:hola_mundo) { create(:published_post, title: 'Hola Mundo') }
      let!(:hola_rails) { create(:published_post, title: 'Hola Rails') }
      let!(:curso_rails) { create(:published_post, title: 'Curso Rails') }

      it "should filter posts by title" do
        get "/posts?search=Hola"
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload.size).to eq(2)
        expect(payload.map { |p| p["id"] }.sort).to eq([hola_mundo.id, hola_rails.id].sort)
        expect(response).to have_http_status(200)
      end
    end

  end

  describe 'with data in the DB' do
    let!(:posts) {  create_list(:post, 10 , published: true) } #esto declara una variabla llamda posts y se le asigna lo que esta dentro del bloque. la parte de 'create list' es de factoby bot y 'let(:post) es de RSpec'  Aqui usamos factory bot para generear datos de prueba
    before { get '/posts'}

    it 'should return all the published posts' do
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /posts/{id}' do
    let!(:post) {  create(:post ) }

    it 'should return a posts' do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(post.id)
      expect(payload['title']).to eq(post.title)
      expect(payload['content']).to eq(post.content)
      expect(payload['published']).to eq(post.published)

      expect(payload['author']['name']).to eq(post.user.name)
      expect(payload['author']['email']).to eq(post.user.email)
      expect(payload['author']['id']).to eq(post.user.id)


      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /posts' do
    let!(:user) { create(:user)}
    it 'should create a new post' do
      req_payload = {
        post: {
          title: 'titulo',
          content: 'contet',
          published: false,
          user_id: user.id
        }
      }
      #POST HTTP
      post '/posts', params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to_not be_nil
      expect(response).to have_http_status(:created)
    end

    it 'should return a error messag on invalid post' do
      req_payload = {
        post: {
          content: 'contet',
          published: false,
          user_id: user.id
        }
      }
      #POST HTTP
      post '/posts', params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['error']).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /posts/{:id} ' do
    let!(:article) { create(:post) }
    it 'should update a post' do
      req_payload = {
        post: {
          title: 'titulo',
          content: 'content',
          published: true
        }
      }
      #POST HTTP
      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(article.id)
      expect(response).to have_http_status(:ok)
    end

    it 'should return a message error message on invalid post' do
      req_payload = {
        post: {
          title: nil,
          content: nil,
          published: true
        }
      }
      #POST HTTP
      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['error']).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end

  end
end

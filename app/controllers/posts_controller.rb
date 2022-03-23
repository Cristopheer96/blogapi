require 'byebug'
class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update] # pregunta: podria ser reemplazado por pundit?

  rescue_from Exception do |e|
    render json: {error: e.message }, status: :internal_error
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def index
    @posts = Post.where(published: true)
    if !params[:search].nil?
      @posts = PostsSearchService.search(@posts, params[:search])
    end

    render json: @posts, status: :ok
  end

  def show
    @post = Post.find(params[:id])
    if (@post.published? || (Current.user && @post.user_id == Current.user.id))
      render json: @post, status: :ok
    else
      render json: {error: "Not Found"}, status: :not_found
    end
  end

  #PUT /post
  def create
    @post = Current.user.posts.create!(create_params)
    render json: @post, status: :created
  end

  def update
    @post = Current.user.posts.find(params[:id])
    @post.update!(update_params)
    render json: @post, status: :ok

  end


  private

  def create_params
    params.require(:post).permit(:title, :content, :published)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end

  def authenticate_user!
    #Bearer xxxx
    token_regex = /Bearer (\w+)/
    #leer hearder de auth
    headers = request.headers
    #verificar quesea validates
    if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
      token = headers['Authorization'].match(token_regex)[1]
      #debemosverifida que el token corresponda aun usuario
        if (Current.user = User.find_by_auth_token(token))

        end
    end
    render json: { error: 'Unathorized'}, status: :unathorized
  end
end

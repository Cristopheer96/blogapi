class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :published, :author

  #como author no es parte del modelo post debemos defniniro

  def author
    user = self.object.user   #Self.objet hacer referecia a post
    {
      name: user.name,
      email: user.email,
      id: user.id
     }
  end
end

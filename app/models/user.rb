class User < ApplicationRecord
  validates :email, presence: true
  validates :name, presence: true
  validates :auth_token, presence: true

  has_many :posts

  after_initialize :generate_auth_token

  def generate_auth_token
    if !auth_token.present?
      self.auth_token = TokenGenerationService.generate
    end
  end

end

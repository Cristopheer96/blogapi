class TokenGenerationService
  def self.generate
    SecureRandom.hex  # esta integrado en rails

  end
end

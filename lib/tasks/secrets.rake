require_relative '../services/secrets_vault'

namespace :secrets do
  desc "Encrypt application.yml"
  task :encrypt do
    SecretsVault.encrypt
  end

  desc "Decrypt application.yml"
  task :decrypt do
    SecretsVault.decrypt
  end
end

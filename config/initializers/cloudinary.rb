# frozen_string_literal: true

# Configuration Cloudinary
# En développement, on utilise le stockage local (voir config/environments/development.rb)
# En production, configurer CLOUDINARY_URL dans les variables d'environnement

if ENV['CLOUDINARY_URL'].present?
  Cloudinary.config_from_url(ENV['CLOUDINARY_URL'])
end

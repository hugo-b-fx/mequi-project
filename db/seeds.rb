# frozen_string_literal: true
require 'open-uri'

puts "🧹 Nettoyage de la base..."
Review.delete_all
FavoriteCoach.delete_all
Message.delete_all
Chat.delete_all
Booking.delete_all
CoachAvailability.delete_all
Coach.delete_all
Horse.delete_all
User.delete_all
ActiveStorage::Blob.all.each { |b| b.purge rescue nil }
ActiveStorage::Attachment.delete_all
ActiveStorage::Blob.delete_all
puts "✅ Base nettoyée !\n\n"

# ==================================
# 📸 URLs photos par genre (Unsplash - URLs vérifiées)
# ==================================

MALE_AVATARS = [
  "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1463453091185-61582044d556?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1552058544-f2b08422138a?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1560250097-0b93528c311a?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1557862921-37829c790f19?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1566492031773-4f4e44671857?w=200&h=200&fit=crop&crop=face"
].freeze

FEMALE_AVATARS = [
  "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&h=200&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=200&h=200&fit=crop&crop=face"
].freeze

HORSE_URLS = [
  "https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1558171813-4c088753af8f?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1450052590821-8bf91254a353?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1509914398892-963f53e6e2f1?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1516466723877-e4ec1d736c8a?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1590595906931-81f04f0ccebb?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1460134583885-129e8e935ab9?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1558171813-4c088753af8f?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1450052590821-8bf91254a353?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1509914398892-963f53e6e2f1?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1516466723877-e4ec1d736c8a?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1590595906931-81f04f0ccebb?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1460134583885-129e8e935ab9?w=400&h=400&fit=crop",
  "https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?w=400&h=400&fit=crop"
].freeze

# Compteurs pour URLs
$male_index = 0
$female_index = 0
$horse_index = 0

def get_male_avatar
  url = MALE_AVATARS[$male_index % MALE_AVATARS.length]
  $male_index += 1
  url
end

def get_female_avatar
  url = FEMALE_AVATARS[$female_index % FEMALE_AVATARS.length]
  $female_index += 1
  url
end

def get_horse_photo
  url = HORSE_URLS[$horse_index % HORSE_URLS.length]
  $horse_index += 1
  url
end

def attach_photo_from_url(record, attribute, url)
  return false unless url.present?
  begin
    file = URI.open(url, read_timeout: 10)
    filename = "#{SecureRandom.hex(8)}.jpg"
    record.photo.attach(io: file, filename: filename, content_type: 'image/jpeg')
    true
  rescue => e
    puts "⚠️  Photo non attachée: #{e.message[0..40]}"
    false
  end
end

# ==================================
# 🏇 Données des 22 Coaches (avec genre)
# ==================================

puts "Création des 22 coachs..."

coaches_data = [
  # Ile-de-France
  { first_name: "Caroline", last_name: "Dubois", gender: :female, email: "caroline.coach@gmail.com",
    phone: "06 12 34 56 78", bio: "Monitrice BEES 2 & DEJEPS – Spécialiste CSO & CCE. 18 ans d'expérience en compétition internationale.",
    specialities: "Saut d'obstacles, Cross, Hunter", level: "Pro", location: "Haras de Jardy, 92430 Marnes-la-Coquette",
    price_per_session: 75, years_experience: 18, latitude: 48.837, longitude: 2.162 },

  { first_name: "Julien", last_name: "Moreau", gender: :male, email: "julien.dressage@gmail.com",
    phone: "06 23 45 67 89", bio: "Champion de France Pro 1 Dressage – Formateur GP. Spécialiste de la reprise libre en musique.",
    specialities: "Dressage, Haute école, Reprise libre", level: "Pro", location: "Écuries de la Reine, 78000 Versailles",
    price_per_session: 90, years_experience: 22, latitude: 48.804, longitude: 2.120 },

  { first_name: "Antoine", last_name: "Petit", gender: :male, email: "antoine.hunter@gmail.com",
    phone: "06 67 89 01 23", bio: "Hunter & Équitation de travail – Préparation equifun et TREC.",
    specialities: "Hunter, Equifun, TREC", level: "Pro", location: "Centre Équestre du Bois de Vincennes, 75012 Paris",
    price_per_session: 60, years_experience: 10, latitude: 48.831, longitude: 2.437 },

  { first_name: "Sophie", last_name: "Laurent", gender: :female, email: "sophie.cso@gmail.com",
    phone: "06 11 22 33 44", bio: "Cavalière internationale CSO 1m50. Formation complète du jeune cheval au haut niveau.",
    specialities: "CSO, Formation jeunes chevaux", level: "Pro", location: "Écurie des Peupliers, 77300 Fontainebleau",
    price_per_session: 85, years_experience: 16, latitude: 48.405, longitude: 2.700 },

  { first_name: "Marc", last_name: "Dupont", gender: :male, email: "marc.endurance@gmail.com",
    phone: "06 55 66 77 88", bio: "Champion de France Endurance – Spécialiste préparation longue distance.",
    specialities: "Endurance, Randonnée", level: "Pro", location: "Centre Équestre de Rambouillet, 78120",
    price_per_session: 70, years_experience: 14, latitude: 48.644, longitude: 1.834 },

  # Normandie
  { first_name: "Thomas", last_name: "Leroy", gender: :male, email: "thomas.eventing@gmail.com",
    phone: "06 45 67 89 01", bio: "Cavalier international CCE – CCI4*. Expert en préparation cross.",
    specialities: "Concours Complet, Cross", level: "Pro", location: "Pôle Équestre de Deauville, 14800",
    price_per_session: 110, years_experience: 20, latitude: 49.360, longitude: 0.075 },

  { first_name: "Claire", last_name: "Bernard", gender: :female, email: "claire.pony@gmail.com",
    phone: "06 56 78 90 12", bio: "Spécialiste Poneys & Enfants – Galop 7. Pédagogie ludique et bienveillante.",
    specialities: "Poney, Baby-poney, Voltige", level: "Pro", location: "Poney Club de Chantilly, 60500",
    price_per_session: 55, years_experience: 15, latitude: 49.185, longitude: 2.460 },

  { first_name: "Pierre", last_name: "Martin", gender: :male, email: "pierre.attelage@gmail.com",
    phone: "06 99 88 77 66", bio: "Champion de Normandie Attelage. Formation complète en attelage de tradition.",
    specialities: "Attelage, Menage", level: "Pro", location: "Haras National du Pin, 61310",
    price_per_session: 95, years_experience: 25, latitude: 48.737, longitude: 0.166 },

  # Sud de la France
  { first_name: "Émilie", last_name: "Rousseau", gender: :female, email: "emilie.western@gmail.com",
    phone: "06 34 56 78 90", bio: "Instructrice AQHA & Western – Barrel Racing & Reining. Ambiance ranch authentique.",
    specialities: "Western, Reining, Barrel Racing", level: "Pro", location: "Ranch des Étoiles, 13790 Rousset",
    price_per_session: 65, years_experience: 12, latitude: 43.485, longitude: 5.622 },

  { first_name: "Lucas", last_name: "Garcia", gender: :male, email: "lucas.doma@gmail.com",
    phone: "06 77 88 99 00", bio: "Spécialiste Doma Vaquera et équitation de travail. Formation chevaux ibériques.",
    specialities: "Doma Vaquera, Équitation ibérique", level: "Pro", location: "Mas des Oliviers, 30000 Nîmes",
    price_per_session: 80, years_experience: 18, latitude: 43.836, longitude: 4.360 },

  { first_name: "Marie", last_name: "Blanc", gender: :female, email: "marie.camargue@gmail.com",
    phone: "06 22 33 44 55", bio: "Éleveuse et formatrice Camargue. Balades et travail du bétail.",
    specialities: "Équitation Camargue, Travail bétail", level: "Pro", location: "Manade de la Mer, 13460 Saintes-Maries",
    price_per_session: 60, years_experience: 20, latitude: 43.451, longitude: 4.428 },

  { first_name: "Alexandre", last_name: "Fabre", gender: :male, email: "alex.polo@gmail.com",
    phone: "06 88 99 00 11", bio: "Joueur de polo professionnel. Initiation et perfectionnement.",
    specialities: "Polo, Horseball", level: "Pro", location: "Polo Club de Cannes, 06250 Mougins",
    price_per_session: 120, years_experience: 15, latitude: 43.600, longitude: 6.989 },

  # Ouest
  { first_name: "Nathalie", last_name: "Guerin", gender: :female, email: "nathalie.ethologie@gmail.com",
    phone: "06 44 55 66 77", bio: "Spécialiste équitation éthologique et travail à pied. Approche naturelle.",
    specialities: "Éthologie, Travail à pied, Liberty", level: "Pro", location: "Écurie du Vent, 44000 Nantes",
    price_per_session: 65, years_experience: 12, latitude: 47.218, longitude: -1.553 },

  { first_name: "Vincent", last_name: "Leroux", gender: :male, email: "vincent.voltige@gmail.com",
    phone: "06 33 22 11 00", bio: "Champion de France Voltige. Formation artistique et sportive.",
    specialities: "Voltige, Gymnastique équestre", level: "Pro", location: "Centre de Voltige de Rennes, 35000",
    price_per_session: 55, years_experience: 14, latitude: 48.117, longitude: -1.677 },

  { first_name: "Isabelle", last_name: "Perrin", gender: :female, email: "isabelle.sidecar@gmail.com",
    phone: "06 12 21 32 43", bio: "Instructrice polyvalente. Spécialiste handicap et équithérapie.",
    specialities: "Équithérapie, Handicap, Loisir", level: "Pro", location: "Centre Équestre Adapté, 29200 Brest",
    price_per_session: 50, years_experience: 18, latitude: 48.390, longitude: -4.486 },

  # Est
  { first_name: "François", last_name: "Meyer", gender: :male, email: "francois.cso@gmail.com",
    phone: "06 54 65 76 87", bio: "Formateur jeunes cavaliers CSO. Préparation compétition club et amateur.",
    specialities: "CSO, Formation club", level: "Pro", location: "Écurie d'Alsace, 67000 Strasbourg",
    price_per_session: 65, years_experience: 11, latitude: 48.573, longitude: 7.752 },

  { first_name: "Céline", last_name: "Muller", gender: :female, email: "celine.dressage@gmail.com",
    phone: "06 98 87 76 65", bio: "Cavalière Grand Prix. Spécialiste rassembler et travail en musique.",
    specialities: "Dressage, Reprise musicale", level: "Pro", location: "Haras de Lorraine, 54000 Nancy",
    price_per_session: 85, years_experience: 19, latitude: 48.692, longitude: 6.184 },

  # Centre
  { first_name: "Philippe", last_name: "Robert", gender: :male, email: "philippe.hunter@gmail.com",
    phone: "06 76 65 54 43", bio: "Juge international Hunter. Formation style et équitation de précision.",
    specialities: "Hunter, Style", level: "Pro", location: "Centre Équestre de Tours, 37000",
    price_per_session: 70, years_experience: 16, latitude: 47.394, longitude: 0.684 },

  { first_name: "Sandrine", last_name: "Girard", gender: :female, email: "sandrine.poney@gmail.com",
    phone: "06 32 43 54 65", bio: "Directrice poney-club. Spécialiste formation poney games et mounted games.",
    specialities: "Poney Games, Mounted Games", level: "Pro", location: "Poney Club du Berry, 18000 Bourges",
    price_per_session: 45, years_experience: 13, latitude: 47.083, longitude: 2.398 },

  # Nord
  { first_name: "Maxime", last_name: "Lefebvre", gender: :male, email: "maxime.cross@gmail.com",
    phone: "06 21 32 43 54", bio: "Spécialiste cross indoor et parcours nature. Préparation mentale cavalier.",
    specialities: "Cross, CCE, Préparation mentale", level: "Pro", location: "Centre Équestre du Nord, 59000 Lille",
    price_per_session: 75, years_experience: 14, latitude: 50.629, longitude: 3.057 },

  { first_name: "Aurélie", last_name: "Simon", gender: :female, email: "aurelie.baby@gmail.com",
    phone: "06 43 32 21 10", bio: "Spécialiste éveil équestre 3-6 ans. Pédagogie Montessori adaptée.",
    specialities: "Baby-poney, Éveil équestre", level: "Pro", location: "Ferme Équestre de Picardie, 80000 Amiens",
    price_per_session: 40, years_experience: 10, latitude: 49.894, longitude: 2.295 },

  { first_name: "Guillaume", last_name: "Duval", gender: :male, email: "guillaume.obstacle@gmail.com",
    phone: "06 65 54 43 32", bio: "Cavalier Pro 2 CSO. Expert en travail des barres et gymnastique.",
    specialities: "CSO, Gymnastique, Barres", level: "Pro", location: "Écuries du Touquet, 62520 Le Touquet",
    price_per_session: 80, years_experience: 17, latitude: 50.521, longitude: 1.588 }
]

coaches = []

coaches_data.each do |data|
  user = User.create!(
    email: data[:email],
    password: "123456",
    password_confirmation: "123456",
    first_name: data[:first_name],
    last_name: data[:last_name],
    phone: data[:phone],
    bio: data[:bio],
    role: "coach"
  )

  # Photo selon genre
  avatar_url = data[:gender] == :male ? get_male_avatar : get_female_avatar
  attach_photo_from_url(user, avatar_url)

  coach = Coach.create!(
    user: user,
    specialities: data[:specialities],
    level: data[:level],
    location: data[:location],
    price_per_session: data[:price_per_session],
    years_experience: data[:years_experience],
    latitude: data[:latitude],
    longitude: data[:longitude]
  )

  coaches << coach
  puts "✅ Coach créé : #{user.full_name} (#{data[:gender] == :male ? '♂' : '♀'})"
end

# ==================================
# 🏇 Création des 10 cavaliers (avec genre)
# ==================================

puts "\nCréation des 10 cavaliers..."

riders_data = [
  { first_name: "Léa", last_name: "Martin", gender: :female, email: "lea.martin@gmail.com", level: "Galop 6", city: "Lyon" },
  { first_name: "Lucas", last_name: "Durand", gender: :male, email: "lucas.durand@gmail.com", level: "Galop 7", city: "Bordeaux" },
  { first_name: "Chloé", last_name: "Lefebvre", gender: :female, email: "chloe.lefebvre@gmail.com", level: "Galop 4", city: "Nantes" },
  { first_name: "Hugo", last_name: "Roux", gender: :male, email: "hugo.roux@gmail.com", level: "Galop 5", city: "Lille" },
  { first_name: "Manon", last_name: "Girard", gender: :female, email: "manon.girard@gmail.com", level: "Galop 7", city: "Marseille" },
  { first_name: "Enzo", last_name: "Morel", gender: :male, email: "enzo.morel@gmail.com", level: "Galop 3", city: "Toulouse" },
  { first_name: "Inès", last_name: "Simon", gender: :female, email: "ines.simon@gmail.com", level: "Galop 6", city: "Strasbourg" },
  { first_name: "Théo", last_name: "Michel", gender: :male, email: "theo.michel@gmail.com", level: "Galop 7 Pro", city: "Paris" },
  { first_name: "Charo", last_name: "Dev", gender: :male, email: "charo@club.com", level: "Galop 7", city: "Paris" },
  { first_name: "Emma", last_name: "Petit", gender: :female, email: "emma.petit@gmail.com", level: "Galop 5", city: "Nice" }
]

riders = []

riders_data.each do |data|
  user = User.create!(
    email: data[:email],
    password: "123456",
    password_confirmation: "123456",
    first_name: data[:first_name],
    last_name: data[:last_name],
    phone: "06 #{rand(10..99)} #{rand(10..99)} #{rand(10..99)} #{rand(10..99)}",
    role: "rider",
    bio: "Cavalier niveau #{data[:level]} – #{data[:city]}"
  )

  # Photo selon genre
  avatar_url = data[:gender] == :male ? get_male_avatar : get_female_avatar
  attach_photo_from_url(user, avatar_url)

  riders << user
  puts "✅ Cavalier créé : #{user.full_name} (#{data[:gender] == :male ? '♂' : '♀'})"
end

# ==================================
# 🐴 Création des 15 chevaux
# ==================================

puts "\nCréation des 15 chevaux..."

horses_data = [
  { name: "Etoile du Soir", age: 8, breed: "Selle Français", discipline: "CSO", owner_email: "lea.martin@gmail.com" },
  { name: "Quartz de Lune", age: 12, breed: "KWPN", discipline: "Dressage", owner_email: "lea.martin@gmail.com" },
  { name: "Hurricane", age: 6, breed: "Hanovrien", discipline: "CCE", owner_email: "lucas.durand@gmail.com" },
  { name: "Bella Vista", age: 10, breed: "Lusitanien", discipline: "Dressage", owner_email: "lucas.durand@gmail.com" },
  { name: "Spirit", age: 14, breed: "Quarter Horse", discipline: "Western", owner_email: "chloe.lefebvre@gmail.com" },
  { name: "Caramel", age: 9, breed: "Connemara", discipline: "Loisir", owner_email: "hugo.roux@gmail.com" },
  { name: "Tonnerre", age: 7, breed: "Selle Français", discipline: "CSO", owner_email: "manon.girard@gmail.com" },
  { name: "Perle Noire", age: 11, breed: "Pure race espagnole", discipline: "Dressage", owner_email: "manon.girard@gmail.com" },
  { name: "Django", age: 5, breed: "Anglo-arabe", discipline: "CCE", owner_email: "enzo.morel@gmail.com" },
  { name: "Olympe", age: 8, breed: "Selle Français", discipline: "CSO", owner_email: "ines.simon@gmail.com" },
  { name: "Feu d'Artifice", age: 9, breed: "Hanovrien", discipline: "Dressage", owner_email: "theo.michel@gmail.com" },
  { name: "Lucky Star", age: 6, breed: "KWPN", discipline: "CSO", owner_email: "theo.michel@gmail.com" },
  { name: "Capitaine", age: 13, breed: "Selle Français", discipline: "CCE", owner_email: "charo@club.com" },
  { name: "Duchesse", age: 10, breed: "Lusitanien", discipline: "Dressage", owner_email: "charo@club.com" },
  { name: "Mistral", age: 7, breed: "Camargue", discipline: "Loisir", owner_email: "emma.petit@gmail.com" }
]

horses = []

horses_data.each do |data|
  owner = User.find_by(email: data[:owner_email])
  horse = Horse.create!(
    user: owner,
    name: data[:name],
    age: data[:age],
    breed: data[:breed],
    discipline: data[:discipline]
  )

  # Photo cheval
  attach_photo_from_url(horse, get_horse_photo)

  horses << horse
  puts "🐴 #{horse.name} (#{horse.breed}) → #{owner.full_name}"
end

# ==================================
# 📅 Disponibilités des coachs
# ==================================

puts "\nCréation des disponibilités..."

days = %w[monday tuesday wednesday thursday friday saturday]

coaches.each do |coach|
  rand(3..5).times do
    start_h = rand(8..16)
    CoachAvailability.create!(
      coach: coach,
      days_off: days.sample,
      start_time: "#{start_h}:00",
      end_time: "#{start_h + rand(2..4)}:00"
    )
  end
end
puts "✅ Disponibilités créées"

# ==================================
# 📘 Réservations (bookings)
# ==================================

puts "\nCréation des réservations..."

# Réservations passées (pour historique)
20.times do
  start_at = Faker::Time.between(from: 60.days.ago, to: 5.days.ago)
  Booking.create!(
    horse: horses.sample,
    coach: coaches.sample,
    status: "completed",
    start_at: start_at,
    end_at: start_at + 1.hour,
    total_price: [45, 55, 60, 65, 70, 75, 80, 85, 90].sample
  )
end

# Réservations à venir (pour charo@club.com)
charo = User.find_by(email: "charo@club.com")
charo_horses = charo.horses

if charo_horses.any?
  [3, 5, 7, 10, 14].each do |days_from_now|
    start_at = Time.current.beginning_of_day + days_from_now.days + rand(9..17).hours
    Booking.create!(
      horse: charo_horses.sample,
      coach: coaches.sample,
      status: ["pending", "confirmed"].sample,
      start_at: start_at,
      end_at: start_at + 1.hour,
      total_price: [65, 75, 85].sample
    )
  end
end

# Réservations passées pour charo (historique)
5.times do
  start_at = Faker::Time.between(from: 30.days.ago, to: 3.days.ago)
  Booking.create!(
    horse: charo_horses.sample,
    coach: coaches.sample,
    status: "completed",
    start_at: start_at,
    end_at: start_at + 1.hour,
    total_price: [65, 75, 85].sample
  )
end if charo_horses.any?

puts "✅ #{Booking.count} réservations créées"

# ==================================
# ⭐ Avis (5-8 par coach)
# ==================================

puts "\nCréation des avis..."

comments_pool = {
  "CSO" => [
    "Séance très structurée, j'ai gagné en trajectoires et en contrôle sur les barres.",
    "Excellente préparation sur les contrats de foulées, conseils précis et applicables.",
    "Coach exigeante mais juste, super feeling et plan de travail clair.",
    "Cours dynamique, grosse progression sur les abords et la qualité du galop.",
    "Parfait pour préparer un parcours, réglages fins et très pédagogiques.",
    "Super travail sur les sauts de puce, mon cheval est beaucoup plus réactif.",
    "Excellent pour la préparation concours, on a travaillé chaque difficulté."
  ],
  "Dressage" => [
    "Très bonne séance de dressage, j'ai enfin compris mes erreurs de mise en main.",
    "Coach très pédagogue, travail fin sur l'équilibre et la rectitude.",
    "Progression visible dès la première séance, explications très claires.",
    "Super conseils sur les transitions et l'impulsion, cheval disponible.",
    "Approche précise et bienveillante, travail sur le contact et la décontraction.",
    "Séance intense mais ultra efficace, on a gagné en cadence et en stabilité.",
    "Super travail sur les pirouettes, progression nette en une heure."
  ],
  "CCE" => [
    "Très bon coaching CCE, travail complet et efficace, très rassurant.",
    "Séance de cross très sécurisée, conseils concrets sur le rythme.",
    "Coach ultra précis, on a vraiment amélioré la qualité du galop.",
    "Super séance, on a progressé sur les combinaisons et la décision.",
    "Excellent cours, correction fine de ma position, cheval plus franc.",
    "Travail sur les contrebas et montées impeccable, beaucoup plus à l'aise.",
    "Coach rassurant et compétent, parfait pour débuter le cross."
  ],
  "Général" => [
    "Super cours, conseils clairs et efficaces, je recommande vivement.",
    "Coach très pédagogue et à l'écoute, séance adaptée à mes besoins.",
    "Séance intense mais très productive, j'ai appris beaucoup.",
    "Progression visible rapidement, méthode structurée et bienveillante.",
    "Très bonne préparation et excellent suivi, coach professionnel.",
    "Explications claires, exercices variés, j'ai adoré cette séance.",
    "Excellent rapport qualité-prix, coach compétent et sympathique."
  ]
}

def get_comments_for_speciality(speciality)
  case speciality
  when /CSO|Saut|obstacle/i then comments_pool["CSO"]
  when /Dressage|Haute école/i then comments_pool["Dressage"]
  when /CCE|Complet|Cross/i then comments_pool["CCE"]
  else comments_pool["Général"]
  end
end

coaches.each do |coach|
  speciality = coach.specialities.split(',').first.strip
  pool = case speciality
         when /CSO|Saut|obstacle/i then comments_pool["CSO"]
         when /Dressage|Haute école/i then comments_pool["Dressage"]
         when /CCE|Complet|Cross/i then comments_pool["CCE"]
         else comments_pool["Général"]
         end

  rand(5..8).times do
    rider = riders.sample
    horse = rider.horses.any? ? rider.horses.sample : horses.sample
    start_at = Faker::Time.between(from: 60.days.ago, to: 5.days.ago)

    booking = Booking.create!(
      horse: horse,
      coach: coach,
      status: "completed",
      start_at: start_at,
      end_at: start_at + 1.hour,
      total_price: coach.price_per_session
    )

    Review.create!(
      user: horse.user,
      booking: booking,
      rating: [3, 4, 4, 4, 5, 5, 5].sample,
      comment: pool.sample
    )
  end
end

puts "✅ #{Review.count} avis créés"

# ==================================
# ❤️ Favoris pour charo@club.com
# ==================================

puts "\nCréation des favoris..."

if charo
  coaches.sample(4).each do |coach|
    FavoriteCoach.create!(user: charo, coach: coach)
  end
  puts "❤️ 4 favoris ajoutés pour Charo"
end

# Favoris pour d'autres riders
riders.sample(3).each do |rider|
  next if rider.email == "charo@club.com"
  coaches.sample(rand(2..3)).each do |coach|
    FavoriteCoach.find_or_create_by!(user: rider, coach: coach)
  end
end

# ==================================
# 📊 Résumé final
# ==================================

puts "\n" + "=" * 50
puts "🎉 SEED TERMINÉE AVEC SUCCÈS !"
puts "=" * 50
puts "Coaches       : #{Coach.count}"
puts "Cavaliers     : #{User.where(role: 'rider').count}"
puts "Chevaux       : #{Horse.count}"
puts "Réservations  : #{Booking.count}"
puts "Avis          : #{Review.count}"
puts "Favoris       : #{FavoriteCoach.count}"
puts "=" * 50

puts "\n📧 Comptes de test :"
puts "-" * 50
puts "Coach     → caroline.coach@gmail.com / 123456"
puts "Cavalier  → lea.martin@gmail.com / 123456"
puts "Dev       → charo@club.com / 123456"
puts "-" * 50
puts "Tous les mots de passe : 123456"
puts ""

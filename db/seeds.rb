puts "🧹 Nettoyage de la base..."
Review.delete_all
Message.delete_all
Chat.delete_all
Booking.delete_all
CoachAvailability.delete_all
Coach.delete_all
Horse.delete_all
User.delete_all
ActiveStorage::Attachment.all.each { |a| a.purge }
puts "✅ Base nettoyée !\n\n"

puts "Création des utilisateurs (cavaliers et coachs)..."

coaches_data = [
  {
    first_name: "Caroline", last_name: "Dubois", email: "caroline.coach@gmail.com",
    phone: "06 12 34 34 56 78", role: "coach", bio: "Monitrice BEES 2 & DEJEPS – Spécialiste CSO & CCE",
    specialities: "Saut d'obstacles, Cross, Hunter", level: "Pro", location: "Haras de Jardy, 92430 Marnes-la-Coquette",
    price_per_session: 75, years_experience: 18, latitude: 48.837, longitude: 2.162, photo_url: "https://res.cloudinary.com/dqdjmhdgi/image/upload/v1765467334/coach4_720_tpvfeu.jpg"
  },
  {
    first_name: "Julien", last_name: "Moreau", email: "julien.dressage@gmail.com",
    phone: "06 23 45 67 89", role: "coach", bio: "Champion de France Pro 1 Dressage – Formateur GP",
    specialities: "Dressage, Reprise libre en musique", level: "Pro", location: "Écuries de la Reine, 78000 Versailles",
    price_per_session: 90, years_experience: 22, latitude: 48.804, longitude: 2.120, photo_url: "https://res.cloudinary.com/dqdjmhdgi/image/upload/v1765467338/coachs1_720_awgmrg.jpg
"
  },
  {
    first_name: "Émilie", last_name: "Rousseau", email: "emilie.western@gmail.com",
    phone: "06 34 56 78 90", role: "coach", bio: "Instructrice AQHA & Western – Barrel Racing & Reining",
    specialities: "Western, Reining, Barrel Racing", level: "Pro", location: "Ranch des Étoiles, 13790 Rousset",
    price_per_session: 65, years_experience: 12, latitude: 43.485, longitude: 5.622, photo_url: "https://res.cloudinary.com/dqdjmhdgi/image/upload/v1765467346/coachs2_720_tgfiwd.jpg"
  },
  {
    first_name: "Thomas", last_name: "Leroy", email: "thomas.eventing@gmail.com",
    phone: "06 45 67 89 01", role: "coach", bio: "Cavalier international CCE – CCI4*",
    specialities: "Concours Complet, Cross indoor", level: "Pro", location: "Pôle Équestre de Deauville, 14800",
    price_per_session: 110, years_experience: 20, latitude: 49.360, longitude: 0.075, photo_url: "https://res.cloudinary.com/dqdjmhdgi/image/upload/v1765467354/coachs3_720_opdq8h.jpg"
  },
  {
    first_name: "Claire", last_name: "Bernard", email: "claire.pony@gmail.com",
    phone: "06 56 78 90 12", role: "coach", bio: "Spécialiste Poneys & Enfants – Galop 7",
    specialities: "Poney, Enseignement enfants, Baby-poney", level: "Pro", location: "Poney Club de Chantilly, 60500",
    price_per_session: 55, years_experience: 15, latitude: 49.185, longitude: 2.460, photo_url: "https://res.cloudinary.com/dqdjmhdgi/image/upload/v1765467358/coachs6_720_pieayf.jpg"
  },
  {
    first_name: "Antoine", last_name: "Petit", email: "antoine.hunter@gmail.com",
    phone: "06 67 89 01 23", role: "coach", bio: "Hunter & Équitation de travail – Préparation equifun",
    specialities: "Hunter, Equifun, TREC", level: "Pro", location: "Centre Équestre du Bois de Vincennes, 75012 Paris",
    price_per_session: 60, years_experience: 10, latitude: 48.831, longitude: 2.437, photo_url: "https://res.cloudinary.com/dqdjmhdgi/image/upload/v1765467366/coachs5_720_b2arbu.jpg"
  }
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
  puts "✅ Coach créé : #{user.full_name}"
end

# ---------------------------
# 🐴 Création des cavaliers
# ---------------------------

riders_data = [
  { first_name: "Léa", last_name: "Martin", email: "lea.martin@gmail.com", level: "Galop 6", city: "Lyon" },
  { first_name: "Lucas", last_name: "Durand", email: "lucas.durand@gmail.com", level: "Galop 7", city: "Bordeaux" },
  { first_name: "Chloé", last_name: "Lefebvre", email: "chloe.lefebvre@gmail.com", level: "Galop 4", city: "Nantes" },
  { first_name: "Hugo", last_name: "Roux", email: "hugo.roux@gmail.com", level: "Galop 5", city: "Lille" },
  { first_name: "Manon", last_name: "Girard", email: "manon.girard@gmail.com", level: "Galop 7", city: "Marseille" },
  { first_name: "Enzo", last_name: "Morel", email: "enzo.morel@gmail.com", level: "Galop 3", city: "Toulouse" },
  { first_name: "Inès", last_name: "Simon", email: "ines.simon@gmail.com", level: "Galop 6", city: "Strasbourg" },
  { first_name: "Théo", last_name: "Michel", email: "theo.michel@gmail.com", level: "Galop 7 Pro 2", city: "Paris" }
]

riders = []

riders_data.each do |data|
  user = User.create!(
    email: data[:email],
    password: "123456",
    password_confirmation: "123456",
    first_name: data[:first_name],
    last_name: data[:last_name],
    phone: "06#{rand(10..99)} #{rand(10..99)} #{rand(10..99)} #{rand(10..99)}",
    role: "rider",
    bio: "Cavalier niveau #{data[:level]} – #{data[:city]}"
  )

  riders << user

  # Chaque cavalier a entre 4 et 8 chevaux
  rand(4..8).times do
    Horse.create!(
      user: user,
      name: FFaker::NameFR.unique.name,
      age: rand(4..22),
      breed: [
        "Selle Français", "Hanovrien", "KWPN", "Holsteiner", "Cheval de sport belge",
        "Pur-sang", "Quarter Horse", "Connemara", "Poney Français de Selle", "Irish Sport Horse",
        "Oldenbourg", "Lusitanien", "PRE", "Anglo-Arabe", "Camargue"
      ].sample,
      discipline: ["CSO", "Dressage", "CCE", "Hunter", "Western", "Poney", "Loisir"].sample
    )
  end

  puts "Cavalier créé : #{user.full_name} – #{user.horses.count} chevaux"
end

puts "\nTotal : #{User.where(role: "coach").count} coachs | #{User.where(role: "rider").count} cavaliers | #{Horse.count} chevaux\n\n"

# ---------------------------
# 📅 Disponibilités coach
# ---------------------------

puts "Création des disponibilités des coachs..."

days = %w[monday tuesday wednesday thursday friday saturday sunday]

coaches.each do |coach|
  rand(4..6).times do
    start_h = rand(8..17)
    CoachAvailability.create!(
      coach: coach,
      days_off: days.sample,
      start_time: "#{start_h}:00",
      end_time: "#{start_h + rand(2..5)}:00"
    )
  end
end

# ---------------------------
# 📘 Bookings
# ---------------------------

puts "Création de 20 réservations..."

20.times do
  start_at = Faker::Time.between(from: 30.days.ago, to: 20.days.from_now)
  Booking.create!(
    horse: Horse.all.sample,
    coach: coaches.sample,
    status: ["confirmed", "pending", "completed", "cancelled"].sample,
    start_at: start_at,
    end_at: start_at + rand(1..3).hours,
    total_price: [55, 60, 65, 75, 90, 110].sample
  )
end

# ---------------------------
# ⭐ Avis
# ---------------------------

puts "Création de 15 avis..."

Booking.where(status: "completed").each do |booking|
  next if rand > 0.7 # 30% seulement ont un avis

  Review.create!(
    user: booking.horse.user,
    booking: booking,
    rating: rand(3..5),
    comment: [
      "Super cours ! Mon cheval a beaucoup progressé.",
      "Coach très pédagogue et à l'écoute.",
      "Séance intense mais efficace.",
      "Progression visible en quelques séances.",
      "Très bonne préparation pour la compétition.",
      "Excellente méthode de dressage.",
      "Merci pour les conseils, séance top !"
    ].sample
  )
end

puts "\nSEED TERMINÉE AVEC SUCCÈS !"
puts "======================================"
puts "Coaches       : #{Coach.count}"
puts "Cavaliers     : #{User.where(role: "rider").count}"
puts "Chevaux       : #{Horse.count}"
puts "Réservations  : #{Booking.count}"
puts "Avis          : #{Review.count}"
puts "======================================\n\n"

puts "Connecte-toi avec :"
puts "Coach → caroline.coach@gmail.com / 123456"
puts "Cavalier → lea.martin@gmail.com / 123456"
puts "Tous les mots de passe sont : 123456"

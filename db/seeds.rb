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
    price_per_session: 75, years_experience: 18, latitude: 48.837, longitude: 2.162
  },
  {
    first_name: "Julien", last_name: "Moreau", email: "julien.dressage@gmail.com",
    phone: "06 23 45 67 89", role: "coach", bio: "Champion de France Pro 1 Dressage – Formateur GP",
    specialities: "Dressage, Reprise libre en musique", level: "Pro", location: "Écuries de la Reine, 78000 Versailles",
    price_per_session: 90, years_experience: 22, latitude: 48.804, longitude: 2.120
  },
  {
    first_name: "Émilie", last_name: "Rousseau", email: "emilie.western@gmail.com",
    phone: "06 34 56 78 90", role: "coach", bio: "Instructrice AQHA & Western – Barrel Racing & Reining",
    specialities: "Western, Reining, Barrel Racing", level: "Pro", location: "Ranch des Étoiles, 13790 Rousset",
    price_per_session: 65, years_experience: 12, latitude: 43.485, longitude: 5.622
  },
  {
    first_name: "Thomas", last_name: "Leroy", email: "thomas.eventing@gmail.com",
    phone: "06 45 67 89 01", role: "coach", bio: "Cavalier international CCE – CCI4*",
    specialities: "Concours Complet, Cross indoor", level: "Pro", location: "Pôle Équestre de Deauville, 14800",
    price_per_session: 110, years_experience: 20, latitude: 49.360, longitude: 0.075
  },
  {
    first_name: "Claire", last_name: "Bernard", email: "claire.pony@gmail.com",
    phone: "06 56 78 90 12", role: "coach", bio: "Spécialiste Poneys & Enfants – Galop 7",
    specialities: "Poney, Enseignement enfants, Baby-poney", level: "Pro", location: "Poney Club de Chantilly, 60500",
    price_per_session: 55, years_experience: 15, latitude: 49.185, longitude: 2.460
  },
  {
    first_name: "Antoine", last_name: "Petit", email: "antoine.hunter@gmail.com",
    phone: "06 67 89 01 23", role: "coach", bio: "Hunter & Équitation de travail – Préparation equifun",
    specialities: "Hunter, Equifun, TREC", level: "Pro", location: "Centre Équestre du Bois de Vincennes, 75012 Paris",
    price_per_session: 60, years_experience: 10, latitude: 48.831, longitude: 2.437
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

puts "Création des avis..."

comments_by_coach = {
  "Caroline" => [
    "Séance très structurée, j’ai gagné en trajectoires et en contrôle sur les barres.",
    "Excellente préparation sur les contrats de foulées, conseils précis et applicables.",
    "Très bon œil sur le couple, on a corrigé des détails qui changeaient tout.",
    "Cours dynamique, grosse progression sur les abords et la qualité du galop.",
    "Coach exigeante mais juste, super feeling et plan de travail clair.",
    "Très bonne mise en confiance sur les combinaisons, j’ai senti une vraie différence.",
    "Parfait pour préparer un parcours, réglages fins et très pédagogiques.",
    "On a travaillé le cross en sécurité, super méthode et beaucoup de sérénité."
  ],
  "Julien" => [
    "Très bonne séance de dressage, j’ai enfin compris mes erreurs de mise en main.",
    "Coach très pédagogue, travail fin sur l’équilibre et la rectitude.",
    "Progression visible dès la première séance, explications très claires.",
    "Super conseils sur les transitions et l’impulsion, cheval beaucoup plus disponible.",
    "Approche précise et bienveillante, gros travail sur le contact et la décontraction.",
    "Très bon coaching pour préparer une reprise, points clés et routine d’échauffement.",
    "Séance intense mais ultra efficace, on a gagné en cadence et en stabilité.",
    "Excellent sur le travail latéral, j’ai senti mon cheval se tendre dans le bon sens."
  ],
  "Émilie" => [
    "Cours top, méthode claire et efficace, j’ai mieux compris le reining.",
    "Super séance de western, beaucoup de précision sans pression inutile.",
    "Très bonne pédagogie, on a travaillé la finesse des aides et la réactivité.",
    "Conseils excellents sur le pattern, progrès net sur les arrêts et les départs.",
    "Coach à l’écoute, séance adaptée à mon niveau, très motivant.",
    "Super sur le barrel, meilleure trajectoire et gestion de vitesse plus propre.",
    "Très bon travail sur la stabilité et la position, gros gain de contrôle.",
    "Approche pro et accessible, j’ai adoré la séance et je reviens vite."
  ],
  "Thomas" => [
    "Très bon coaching CCE, travail complet et efficace, très rassurant.",
    "Séance de cross très sécurisée, conseils concrets sur le rythme et les abords.",
    "Coach ultra précis, on a vraiment amélioré la qualité du galop et des sauts.",
    "Super séance, on a progressé sur les combinaisons et la décision à l’obstacle.",
    "Très bon accompagnement, méthode claire et gros focus sur la confiance.",
    "Prépa concours au top, gestion du parcours et stratégie très pertinentes.",
    "Excellent cours, correction fine de ma position, cheval plus franc et régulier.",
    "Très bonne séance, j’ai gagné en fluidité et en efficacité sur le cross."
  ],
  "Claire" => [
    "Super coach avec les enfants, très patiente et rassurante, ma fille a adoré.",
    "Séance ludique et efficace, beaucoup de progrès sur l’équilibre et la direction.",
    "Très bon cours poney, exercices adaptés et ambiance super positive.",
    "Coach très bienveillante, mon enfant a pris confiance rapidement.",
    "Très bonne pédagogie, explications simples et motivantes pour les plus jeunes.",
    "Séance nickel, beaucoup de jeux utiles et une vraie progression.",
    "Top pour le baby-poney, cadre sécurisant et activités variées.",
    "Excellente approche, mon enfant veut déjà reprendre un cours !"
  ],
  "Antoine" => [
    "Très bonne séance de hunter, amélioration nette des courbes et de la précision.",
    "Super coach, exercices progressifs et très formateurs, ambiance agréable.",
    "Séance efficace, on a gagné en régularité et en qualité de galop.",
    "Très bon travail sur les contrats et la rectitude, conseils simples et justes.",
    "Coach pédagogue, bon œil, et exercices variés, je recommande.",
    "Très bonne séance equifun, super pour la confiance et la précision.",
    "Cours top, on a travaillé la technique sans se crisper, gros progrès.",
    "Séance très complète, j’ai une vraie base de travail pour continuer seul."
  ]
}

coaches.each do |coach|
  coach_name = coach.user.first_name
  comments_pool = comments_by_coach[coach_name] || [
    "Super cours, conseils clairs et efficaces.",
    "Coach très pédagogue et à l'écoute.",
    "Séance intense mais très productive.",
    "Progression visible rapidement, je recommande.",
    "Très bonne préparation et excellent suivi."
  ]

  target_reviews = rand(5..8)

  target_reviews.times do
    rider = riders.sample
    horse = rider.horses.sample
    start_at = Faker::Time.between(from: 25.days.ago, to: 2.days.ago)

    booking = Booking.create!(
      horse: horse,
      coach: coach,
      status: "completed",
      start_at: start_at,
      end_at: start_at + rand(1..3).hours,
      total_price: coach.price_per_session
    )

    Review.create!(
      user: booking.horse.user,
      booking: booking,
      rating: [3, 4, 4, 5, 5].sample,
      comment: comments_pool.sample
    )
  end
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

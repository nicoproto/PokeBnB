require "open-uri"
require 'json'
require 'nokogiri'

def line
  puts "-------------------------------------"
end

def dots
  puts "............."
end

EMOJI = ["π", "π", "π€", "πͺ", "π", "π", "π¦Ύ"].freeze

# ---------- STARTING SEEDING ----------

puts "π§ΉCleaning up the database"
Kind.destroy_all
Pokemon.destroy_all
User.destroy_all
puts "Done deleting database β"

line

puts "π΅οΈββοΈ Getting seeding information Yaml files"

puts " - finding reviews π£"

file_path = Rails.root.join("db", "seed_reviews.yml")
seed_file = YAML::load_file(file_path)
reviews = seed_file['reviews']

puts " - finding locations π"

file_path = Rails.root.join("db", "seed_locations.yml")
seed_file = YAML::load_file(file_path)
locations = seed_file['barcelona_locations']

puts " - finding pokemon trainers π₯"

file_path = Rails.root.join("db", "seed_trainers.yml")
seed_file = YAML::load_file(file_path)
trainers = seed_file['trainers']

puts " - finding pokemons π¦ πΈ π"
file_path = Rails.root.join("db", "seed_pokemons.yml")
seed_file = YAML::load_file(file_path)

pokemons = []
seed_file['pokemons'].each_with_index do |pokemon, index|
  pokemons << pokemon.downcase.gsub(" ", "-")
end

puts "Seeding information retrieved β"


puts "π₯ Creating trainers "
trainers.each do |trainer|
  new_trainer = User.create!(email: trainer["email"], password: "password", nickname: trainer["nickname"])
  # new_trainer_avatar = URI.open(trainer["avatar"])
  # new_trainer.avatar.attach(io: new_trainer_avatar, filename: "#{new_trainer.nickname}_avatar.png", content_type: 'image/png')
  puts "Pokemon trainer #{new_trainer.nickname.capitalize} ready to battle ππ»"
end

puts "π₯ Done creating users β"
line

location_index = 0

puts "π¨βπ¬ Creating new pokemons... π©βπ¬"
pokemons.each do |pokemon_name|
  # Getting pokemon name and type
  poke_info_url = "https://pokeapi.co/api/v2/pokemon/#{pokemon_name.downcase}"

  pokemon_serialized = URI.open(poke_info_url).read
  pokemon = JSON.parse(pokemon_serialized)

  # Go to next if it's already created
  puts "Creating *#{pokemon['species']['name'].capitalize}* π§ͺ"
  puts "- Type: #{pokemon['types'][0]['type']['name'].capitalize}"

  # Getting pokemon description
  poke_description_url = "https://www.pokemon.com/us/pokedex/#{pokemon['species']['name']}"

  html_file = URI.open(poke_description_url).read
  html_doc = Nokogiri::HTML(html_file)

  pokemon_description = html_doc.search('.version-x.active')[0].text.strip

  # Creating new pokemon object
  new_pokemon = Pokemon.new(
    name: pokemon['species']['name'],
    description: pokemon_description,
    price: (rand(45..250)),
    location: locations[location_index],
    user: User.all.sample
  )

  pokemon['types'].each do |pokemon_type|
    kind = Kind.find_or_create_by!(name: pokemon_type["type"]["name"])
    KindPokemon.create!(pokemon: new_pokemon, kind: kind)
  end

  location_index += 1

  puts "β #{new_pokemon.name.capitalize} created! #{EMOJI.sample} - Total actual pokemons: #{Pokemon.count}" if new_pokemon.save!

  # Getting pokemon photo and attaching it to pokemon instance
  pokemon_id = pokemon["id"].to_s.rjust(3, "0")

  pokemon_photo_url = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/#{pokemon_id}.png"
  pokemon_photo = URI.open(pokemon_photo_url)
  new_pokemon.photo.attach(io: pokemon_photo, filename: "#{pokemon["species"]["name"]}.png", content_type: 'image/png')

  line
  sleep(3)
end

puts "Creating bookings and reviews for all pokemons"
Pokemon.all.each do |pokemon|
  start_date = Date.today - rand(45..250)
  end_date = start_date + rand(2..20)
  user = User.where.not(email: pokemon.user.email).sample

  booking = Booking.new(
    start_date: start_date,
    end_date: end_date,
    pokemon: pokemon,
    user: user
  )
  booking.save(validate: false)
  # TODO: Randomize this to be between accepted and declined
  booking.status = "accepted"
  booking.save!(validate: false)
  puts "β Booking created: #{user.nickname.capitalize} booked #{pokemon.name.capitalize} from #{start_date} to #{end_date}."

  review = Review.new(reviews.sample)
  review.booking = booking
  review.save!(validate: false)
  puts "    β #{user.nickname.capitalize} reviewed this booking with a #{review.rating}"
  line
end

puts "Total pokemons πΆ: #{Pokemon.count}"
puts "Total users π₯: #{User.count}"
puts "Total bookings π§Ύ: #{Booking.count}"
puts "Total reviews π£: #{Review.count}"
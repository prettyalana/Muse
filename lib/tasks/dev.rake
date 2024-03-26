desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  p "Creating sample data"

  if Rails.env.development?
    Category.destroy_all
    Listing.destroy_all
    Message.destroy_all
    Offer.destroy_all
    User.destroy_all
  end

  12.times do
    name = Faker::Name.first_name
    username = Faker::Name.name
    address = Faker::Address.full_address
    bio = Faker::Quote.matz
    location = Faker::Address.city
    u = User.create(
      email: "#{name}@example.com",
      password: "password",
      username: name,
      name: username,
      address: address,
      image: "https://robohash.org/#{rand(9999)}",
      bio: bio,
      location: location,
    )
  end

  3.times do
    category = Category.new
    categories = Category.create(
      name: category.name
    )
  end

  users = User.all

  users.each do |user|
    category = Category.new
    rand(15).times do
      listings = user.purchased_listings.create!(
        caption: Faker::Lorem.sentence,
        image: "https://robohash.org/#{rand(9999)}",
        category: category
      )
    end
  end


  users.each do |user|
    rand(15).times do
      listing = Listing.new
      message = Message.new
      offer = user.sent_offers.create!(
        description: Faker::Lorem.sentence,
        listing: listing,
        image: "https://robohash.org/#{rand(9999)}",
        price: rand(1000),
        message: message
      )
    end
  end

  message = Faker::Lorem.sentence
  listing = Listing.new
  users.each do |seller|
    users.each do |buyer|
      if rand < 0.75
        seller.sent_messages.create!(
          sender: seller, 
          recipient: buyer,
          listing: listing,
          body: message,
        )
      end

      if rand < 0.75
        buyer.received_messages.create!(
          sender: buyer,
          recipient: seller,
          listing: listing,
          body: message,
        )
      end
    end
  end

  p "There are now #{User.count} users."
  p "There are now #{Offer.count} offers."
  p "There are now #{Listing.count} listings."
  p "There are now #{Message.count} messages."
  p "There are now #{Category.count} categories."
end

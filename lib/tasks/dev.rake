require "open-uri"
require "faker"

desc "Fill the database tables with some sample data"
task({ sample_data: :environment }) do
  p "Creating sample data"
  starting = Time.now

  if Rails.env.development?
    Category.destroy_all
    Listing.destroy_all
    Message.destroy_all
    Offer.destroy_all
    User.destroy_all
    p "Database wiped"
  end

  # Create users
  12.times do
    username = Faker::Name.first_name.downcase
    name = Faker::Name.name.titleize
    address = Faker::Address.full_address
    bio = Faker::Quote.matz
    location = Faker::Address.city
    account_types = User.account_types.keys.sample
    avatar_url = "https://robohash.org/#{rand(9999)}?set=set4"

    u = User.create(
      username: username,
      email: "#{username}@example.com",
      password: "password",
      name: name,
      address: address,
      bio: bio,
      location: location,
      account_type: account_types,
    )

    u.avatar.attach(io: URI.open(avatar_url), filename: "avatar_#{u.username}.png")
  end

  p "Created #{User.count} users."

  # Create categories
  until Category.count == 10
    category_name = Faker::Commerce.department(max: 1, fixed_amount: true)
    Category.create(name: category_name) unless Category.where(name: category_name).exists?
  end

  p "Created #{Category.count} categories."

  # Create listings
  image_ids = [8, 20, 21, 23, 24, 26, 39, 48, 76, 96, 157, 250, 403, 464, 486, 527]

  User.where(account_type: "buyer").each do |user|
    rand(15).times do
      listing_image_url = "https://picsum.photos/id/#{image_ids.sample}/800/600"
      listing = user.listings.new(
        caption: Faker::Lorem.sentence,
        category: Category.all.sample,
        purchased: [true, false].sample,
      )

      # Attempt to attach the image first
      begin
        listing.image.attach(io: URI.open(listing_image_url), filename: "listing_image_#{listing.id}.png")
        listing.save!
      rescue => e
        puts "Error attaching image or saving listing for user #{user.username}: #{e.message}"
      end
    end
  end

  p "Created #{Listing.count} listings."

  # Create messages
  Listing.all.each do |listing|
    5.times do
      sender = User.where(account_type: "seller").sample
      listing.messages.create(body: Faker::Lorem.sentence, sender: sender, recipient: listing.buyer)
      listing.messages.create(body: Faker::Lorem.sentence, sender: listing.buyer, recipient: sender)
    end
  end

  p "Created #{Message.count} messages."

  # Create offers
Listing.all.each do |listing|
  messages = listing.messages.where.not(sender_id: listing.buyer)
  if messages.any?
    rand(2..3).times do
      message = messages.sample
      # Ensure that we're passing the actual blob
        Offer.create(
          description: Faker::Lorem.sentence,
          image: listing.image.blob,  # This should reference the actual attached blob
          price: rand(1000),
          listing_id: listing.id,
          seller_id: message.sender_id,
          message_id: message.id,
        )
    end
  end
end


  p "Created #{Offer.all.count} offers."

  p "There are now #{User.count} users."
  p "There are now #{Category.count} categories."
  p "There are now #{Listing.count} listings."
  p "There are now #{Message.count} messages."
  p "There are now #{Offer.count} offers."
end

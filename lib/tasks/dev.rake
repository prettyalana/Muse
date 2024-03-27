desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
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

  12.times do
    username = Faker::Name.first_name
    name = Faker::Name.name
    address = Faker::Address.full_address
    bio = Faker::Quote.matz
    location = Faker::Address.city
    account_types = User.account_types.keys.sample
    u = User.create(
      username: username.downcase,
      email: "#{username}@example.com",
      password: "password",
      name: name,
      address: address,
      image: "https://robohash.org/#{rand(9999)}",
      bio: Faker::Quote.matz,
      location: Faker::Address.city,
      account_type: account_types
    )
  end

  p "Created #{User.all.count} users."

  until Category.all.length == 10
    category = Faker::Commerce.department(max: 1, fixed_amount: true)
    Category.create(name: category) unless Category.where(name: category).length != 0
  end

  p "Created #{Category.all.count} categories."

  User.where(account_type: "buyer").each do |user|
    rand(15).times do
      user.listings.create(
        caption: Faker::Lorem.sentence,
        image: "https://robohash.org/#{rand(9999)}",
        category: Category.all.sample,
        purchased: [true, false].sample
      )
    end
  end

  p "Created #{Listing.all.count} listings."

  # Ensure there is at least one user with no listings
  User.all.sample.listings.destroy_all

  Listing.purchased_listings.each do |listing|
    5.times do
      listing.messages.create(
        body: Faker::Lorem.sentence,
        sender: User.where(account_type: "seller").sample,
        recipient: listing.buyer
      )
      listing.messages.create(
        body: Faker::Lorem.sentence,
        sender: listing.buyer,
        recipient: User.where(account_type: "seller").sample
      )
    end
  end

  p "Created #{Message.all.count} messages."

  Listing.all.each do |listing|
    messages = listing.messages.where.not(sender_id: listing.buyer)
    if messages.count != 0
      2..3.times do
        messages.where.not(sender_id: listing.buyer).each do |message|
          Offer.create(
            description: Faker::Lorem.sentence,
            image: "https://robohash.org/#{rand(9999)}",
            price: rand(1000), # fix this
            listing_id: listing.id,
            seller_id: message.sender_id,
            message_id: message.id
            # status: # add this later
          )
        end
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

# This is if I want only the "clothing", "shoes", and "accessories" categories to be present in my database

# ["clothing", "shoes", "accessories"].each do | category |
#   Category.create(
#   name: category
# )
# end

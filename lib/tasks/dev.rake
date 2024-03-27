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
      bio: Faker::Quote.matz,
      location: Faker::Address.city,
    )
  end

  p "Created #{User.all.count} users."

  until Category.all.length == 12
    category = Faker::Commerce.department(max: 1, fixed_amount: true)
    Category.create(name: category) unless Category.where(name: category).length != 0
  end

  p "Created #{Category.all.count} categories."

  User.all.each do |user|
    rand(15).times do
      user.listings.create(
        caption: Faker::Lorem.sentence,
        image: "https://robohash.org/#{rand(9999)}",
        category: Category.all.sample,
        purchased: [true, false].sample,
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
        sender: User.where.not(id: listing.buyer).sample,
        recipient: listing.buyer,
      )
      listing.messages.create(
        body: Faker::Lorem.sentence,
        sender: listing.buyer,
        recipient: User.where.not(id: listing.buyer).sample,
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
            message_id: message.id,
            # status: # add this
          )
        end
      end
    end
  end
  # p Listing.all.sample.offers
  p "Created #{Offer.all.count} offers."

  p "There are now #{User.count} users."
  p "There are now #{Category.count} categories."
  p "There are now #{Listing.count} listings."
  p "There are now #{Message.count} messages."
  p "There are now #{Offer.count} offers."
end

#   users.each do |user|
#     rand(15).times do
#       listing = Listing.new
#       message = Message.new
#       offer = user.sent_offers.create!(
#         description: Faker::Lorem.sentence,
#         listing: listing,
#         image: "https://robohash.org/#{rand(9999)}",
#         price: rand(1000),
#         message: message
#       )
#     end
#   end

#   message = Faker::Lorem.sentence
#   listing = Listing.new
#   users.each do |seller|
#     users.each do |buyer|
#       if rand < 0.75
#         seller.sent_messages.create!(
#           sender: seller,
#           recipient: buyer,
#           listing: listing,
#           body: message
#         )
#       end

#       if rand < 0.75
#         buyer.replied_messages.create!(
#           sender: buyer,
#           recipient: seller,
#           listing: listing,
#           body: message
#         )
#       end
#     end
#   end

# 12.times do
#   name = Faker::Name.first_name
#   username = Faker::Name.name
#   u = User.create(
#     email: "#{name}@example.com",
#     password: "password",
#     username: name,
#     name: username,
#     address: address,
#     bio: bio,
#     location: location,
#   )
# end

# ["clothing", "shoes", "accessories"].each do | category |
#   Category.create(
#   name: category
# )
# end

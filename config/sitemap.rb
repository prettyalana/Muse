SitemapGenerator.verbose = false

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://muse-shopping.com"

SitemapGenerator::Sitemap.create do
  # Add static pages
  add '/', priority: 1.0, changefreq: 'daily'   # root path (landing page)
  add '/home', priority: 0.8, changefreq: 'monthly'   # /home page

  # Add user profile pages
  User.find_each do |user|  # Loop through each user to create their profile URL
    add user_path(user.username), lastmod: user.updated_at
  end

  # Add offers
  Offer.find_each do |offer|  # Loop through each offer to create its URL
    add offer_path(offer), lastmod: offer.updated_at
  end

  # Add categories
  Category.find_each do |category|  # Loop through each category to create its URL
    add category_path(category), lastmod: category.updated_at
  end

  # Add listings
  Listing.find_each do |listing|  # Loop through each listing to create its URL
    add listing_path(listing), lastmod: listing.updated_at
  end

  # Add messages (if necessary)
  Message.find_each do |message|  # Loop through each message to create its URL
    add message_path(message), lastmod: message.updated_at
  end
end

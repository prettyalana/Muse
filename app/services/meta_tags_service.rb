class MetaTagsService
  def self.default_meta_tags
    image_url = Rails.application.routes.url_helpers.asset_url('Muse-2.png', host: 'https://muse-shopping.com')

    {
      site: "Muse",
      image: image_url,
      description: "Muse is a customer-driven app that prioritizes the customer's needs by connecting buyers directly with sellers, merchants, and retailers, and offering a platform to curate personalized shopping lists.",
      og: {
        title: "Muse - A Brand New Customer-Driven Shopping Experience",
        image: image_url,
        description: "The best app to find exactly what you're looking for. Create listings for what you want, and let the sellers come to you. Curate your perfect shopping list and discover products you actually want.",
        site_name: "Muse"
      }
    }
  end
end

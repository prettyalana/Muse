module ApplicationHelper
  def default_meta_tags
    {
      site: "Muse",
      image: image_url('/assets/Muse-2.png'),
      description: "An app made for the customer by the customer.",
      og: {
        title: "Muse",
        image: image_url('/assets/Muse-2.png'),
        description: "An app made for the customer by the customer.",
        site_name: "muse-shopping.com"
      }
      # TODO: add twitter tags
    }
  end
end

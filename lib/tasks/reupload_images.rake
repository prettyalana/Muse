# lib/tasks/reupload_images.rake
namespace :reupload do
  desc "Reupload images to listings"
  task images: :environment do
    listings_data = [
      { id: 2, original_image_url: "https://images.pexels.com/photos/8386641/pexels-photo-8386641.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" },
      { id: 3, original_image_url: "https://images.pexels.com/photos/11203750/pexels-photo-11203750.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" },
      { id: 12, original_image_url: "https://images.pexels.com/photos/8386641/pexels-photo-8386641.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" },
      { id: 4, original_image_url: "https://images.pexels.com/photos/8386641/pexels-photo-8386641.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" },
      { id: 1, original_image_url: "https://images.pexels.com/photos/4602025/pexels-photo-4602025.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" },
      { id: 13, original_image_url: "https://images.pexels.com/photos/13662407/pexels-photo-13662407.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1" },
      { id: 5, original_image_url: "https://images.pexels.com/photos/5154015/pexels-photo-5154015.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" },
      { id: 14, original_image_url: "https://imgs.search.brave.com/OSHzHVLl50wHXCOVgUO2391_zb6bGbIxh-m_4pboXxc/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9uZXdz/LmFydG5ldC5jb20v/YXBwL25ld3MtdXBs/b2FkLzIwMjEvMDcv/TWljaGFlbC1Kb3Jk/YW4tU2lnbmVkLSVF/MiU4MCU5OFBsYXll/ci1TYW1wbGUlRTIl/ODAlOTktRGVhZHN0/b2NrLUFpci1Kb3Jk/YW4tMTEtJUUyJTgw/JTk4U3BhY2UtSmFt/JUUyJTgwJTk5LTEw/MjR4MTAyNC5qcGc" },
      { id: 9, original_image_url: "https://images.pexels.com/photos/19577865/pexels-photo-19577865/free-photo-of-men-shoes-creative-for-e-commerce.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" },
      { id: 11, original_image_url: "https://images.unsplash.com/photo-1458538977777-0549b2370168?q=80&w=2674&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" },
    ]

    listings_data.each do |data|
      listing = Listing.find_by(id: data[:id])
      if listing
        if data[:original_image_url].present?
          # Attach the image from the URL
          image_url = data[:original_image_url]
          listing.image.attach(io: URI.open(image_url), filename: File.basename(image_url))
          puts "Attached image to Listing ID #{listing.id} from #{image_url}."
        else
          puts "No image URL for Listing ID #{listing.id}, skipping."
        end
      else
        puts "Listing ID #{data[:id]} not found."
      end
    end

    puts "Finished reuploading images."
  end
end

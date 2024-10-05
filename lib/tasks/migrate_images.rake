require 'open-uri'
require 'mini_mime' # Make sure to add this gem to your Gemfile

namespace :migrate do
  desc "Migrate existing images from URLs to AWS S3"
  task images: :environment do
    Rails.env = "production"
    Listing.find_each do |listing|
      if listing.image.present? && listing.image.service_name != 'amazon'
        begin
          image_url = listing.image
          file_name = File.basename(URI.parse(image_url).path)

          open(image_url) do |image_file|
            # Determine content type based on filename extension
            content_type = MiniMime.lookup_by_filename(file_name)&.type || 'application/octet-stream'

            # Attach the image to AWS S3
            listing.image.attach(
              io: image_file,
              filename: file_name,
              content_type: content_type
            )
          end

          Rails.logger.info "Migrated image for listing ##{listing.id} to AWS S3"
        rescue => e
          Rails.logger.error "Failed to migrate image for listing ##{listing.id}: #{e.message}"
        end
      end
    end
  end
end
